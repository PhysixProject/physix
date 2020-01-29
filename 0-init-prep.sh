#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh
source ./build.conf

PWD=`pwd`

user=`whoami`
if [ $user != 'root' ] ; then
	echo "Must run this as user: root. Exiting..."
	exit 1
fi


# ---------------------------------------------------------------
# Create 3 partitions
#  - 1: 1GB Future EFI boot partition (not implemented)
#  - 2: 1GB boot partition
#  - 3: LVM partition
#       - /dev/mapper/physix-root
#       - /dev/mapper/physix-home
#-----------------------------------------------------------------
function init_storage_lvm() {

	ls /dev/mapper/ | grep -q "$CONF_VOL_GROUP_NAME-"
	if [ $? -eq 0 ] ; then
		echo "[ERROR] a Volume group named CONF_VOL_GROUP_NAME already exists on this system"
		echo "Please set anohter name in build.conf"
		exit 1
	fi

        local NUM_PARTITIONS=`ls /dev/ | grep $CONF_ROOT_DEVICE | wc -l`
        if [ $NUM_PARTITIONS -gt 1 ] ; then
                lsblk -f
		echo ""
		echo "[ERROR] Found existing partitions on /dev/$CONF_ROOT_DEVICE"
                echo "  If this is the device you wish to install to, Please remove all"
		echo "  Partitions from /dev/$CONF_ROOT_DEVICE, first."
                echo "Exiting."
                exit 1
        fi


#FIND TOOLS
	if [ $CONF_ROOTPART_FS ] ; then
		MKFS=`which mkfs.$CONF_ROOTPART_FS`
		if [ ! -e $MKFS ] ; then
        		echo "[ERROR] mkfs.$MKFS NOT FOUND in path. exiting..."
        		exit 1
		fi
	else
		MKFS=`which mkfs.ext4`
		if [ ! -e $MKFS ] ; then
			echo "[ERROR] Default: mkfs.btrfs NOT FOUND in path. exiting..."
			exit 1
		fi
	fi

	local PARTED=`which parted`
	if [ ! -e $PARTED ] ; then
        	echo "[ERROR] parted tool NOT FOUND in path. exiting..."
        	exit 1
	fi

	local MKFAT=`which mkfs.fat`
	if [ ! -e $MKFAT ] ; then
        	echo "[ERROR] mkfs.FAT NOT FOUND in path. exiting..."
        	exit 1
	fi
	
	local MKEXT2=`which mkfs.ext2`
	if [ ! -e $MKEXT2 ] ; then
        	echo "[ERROR] mkfs.ext2 NOT FOUND in path. exiting..."
        	exit 1
	fi




#CREATE PARTITIONS	
        report "Creating Partitions"
	eval $PARTED /dev/$CONF_ROOT_DEVICE mklabel msdos 1


	# SETUP UEFI Partition
	PREV_LIMIT=0
	if [ $CONF_UEFI_PART_SIZE ] ; then
		eval $PARTED /dev/$CONF_ROOT_DEVICE mkpart primary 1 $CONF_UEFI_PART_SIZE
		if [ $? -ne 0 ] ; then
			report "[ERROR] create primary 1 $CONF_UEFI_PART_SIZE"
			exit 1
		fi
		report "$PARTED /dev/$CONF_ROOT_DEVICE mkpart primary 1 $CONF_UEFI_PART_SIZE"
		PREV_LIMIT=$CONF_UEFI_PART_SIZE
	else
		# DEFAULT 1024 MB
		eval $PARTED /dev/$CONF_ROOT_DEVICE mkpart primary 1 1024
		if [ $? -ne 0 ] ; then
			report "[ERROR] create primary 1 1024"
			exit 1
		fi
		report "$PARTED /dev/$CONF_ROOT_DEVICE mkpart primary 1 1024"
		PREV_LIMIT=1024
	fi 


	# SETUP BOOT Partition
	if [ $CONF_BOOT_PART_SIZE ] ; then
		LIMIT=$((PREV_LIMIT+CONF_BOOT_PART_SIZE))
		eval $PARTED /dev/$CONF_ROOT_DEVICE mkpart primary $PREV_LIMIT $LIMIT
		if [ $? -ne 0 ] ; then
			report "[ERROR] create primary $PREV_LIMIT $LIMIT"
			exit 1
		fi
		report "$PARTED /dev/$CONF_ROOT_DEVICE mkpart primary $PREV_LIMIT $LIMIT"
		PREV_LIMIT=$LIMIT
	else
		# DEFAULT: ~500 MB
		LIMIT=$((PREV_LIMIT+600))
		eval $PARTED /dev/$CONF_ROOT_DEVICE mkpart primary $PREV_LIMIT $LIMIT
		if [ $? -ne 0 ] ; then
			report "[ERROR] create primary $PREV_LIMIT $LIMIT"
			exit 1
		fi
		report "$PARTED /dev/$CONF_ROOT_DEVICE mkpart primary $PREV_LIMIT $LIMIT"
		PREV_LIMIT=$LIMIT
	fi


	if [ $CONF_PHYS_ROOT_PART_SIZE ] ; then
		LIMIT=$((PREV_LIMIT+CONF_PHYS_ROOT_PART_SIZE))
		eval $PARTED /dev/$CONF_ROOT_DEVICE mkpart primary $PREV_LIMIT $LIMIT
		if [ $? -ne 0 ] ; then
			report "[ERROR] create primary $PREV_LIMIT $LIMIT"
			exit 1
		fi
		report "$PARTED /dev/$CONF_ROOT_DEVICE mkpart primary $PREV_LIMIT $LIMIT"
	else
		# Default: 50 GB
		LIMIT=$((PREV_LIMIT+50000))
		eval $PARTED /dev/$CONF_ROOT_DEVICE mkpart primary $PREV_LIMIT $LIMIT
		if [ $? -ne 0 ] ; then
			report "[ERROR] create primary $PREV_LIMIT $LIMIT"
			exit 1
		fi
		report "$PARTED /dev/$CONF_ROOT_DEVICE mkpart primary $PREV_LIMIT $LIMIT"
	fi


	eval $PARTED /dev/$CONF_ROOT_DEVICE set 1 boot on
	if [ $? -ne 0 ] ; then
		report "[ERROR] parted /dev/$CONF_ROOT_DEVICE set 1 boot on"
		exit 1
	fi


#CREATE LOGICAL VOLUES

	pvcreate -ff /dev/"$CONF_ROOT_DEVICE"3
	if [ $? -ne 0 ] ; then
        	report "[ERROR] Createing Physical Volume $CONF_ROOT_DEVICE'3'. exiting..."
        	exit 1
	fi

	vgcreate $CONF_VOL_GROUP_NAME /dev/"$CONF_ROOT_DEVICE"3
	if [ $? -ne 0 ] ; then
		report "[ERROR] vgcreate $CONF_VOL_GROUP_NAME /dev/$CONF_ROOT_DEVICE'3'"
        	exit 1
	fi

	#CREATE / LOGICAL VOLUME
	if [ $CONF_LOGICAL_ROOT_SIZE ] ; then
		lvcreate -L "$CONF_LOGICAL_ROOT_SIZE"G -n root $CONF_VOL_GROUP_NAME
		if [ $? -ne 0 ] ; then
			report "[ERROR] lvcreate -L 100G -n root $CONF_VOL_GROUP_NAME"
			exit 1
		fi
	else
		lvcreate -L 10G -n root $CONF_VOL_GROUP_NAME
		if [ $? -ne 0 ] ; then
			report "lvcreate -L 10G -n root $CONF_VOL_GROUP_NAME"
			exit 1
		fi
	fi

	#CREATE /home LOGICAL VOLUME
	if [ $CONF_LOGICAL_HOME_SIZE ] ; then
		lvcreate -L "$CONF_LOGICAL_HOME_SIZE"G -n home $CONF_VOL_GROUP_NAME
		if [ $? -ne 0 ] ; then
			report "[ERROR] lvcreate -L 150G -n home $CONF_VOL_GROUP_NAME"
			exit 1
		fi
	else
		lvcreate -L 10G -n home $CONF_VOL_GROUP_NAME
		if [ $? -ne 0 ] ; then
			report "[ERROR] lvcreate -L 150G -n home $CONF_VOL_GROUP_NAME"
			exit 1
		fi
	fi

	#CREATE /var LOGICAL VOLUME
	if [ $CONF_LOGICAL_VAR_SIZE ] ; then
		lvcreate -L "$CONF_LOGICAL_VAR_SIZE"G -n var $CONF_VOL_GROUP_NAME
		if [ $? -ne 0 ] ; then
			report "[ERROR] lvcreate -L $CONF_LOGICAL_VAR_SIZE GB -n var $CONF_VOL_GROUP_NAME"
			exit 1
		fi
	else
                lvcreate -L 5G -n var $CONF_VOL_GROUP_NAME
		if [ $? -ne 0 ] ; then
			report "[ERROR] lvcreate -L $CONF_LOGICAL_VAR_SIZE GB -n var $CONF_VOL_GROUP_NAME"
			exit 1
		fi
	fi

	#CREATE /usr LOGICAL VOLUME
	if [ $CONF_LOGICAL_USR_SIZE ] ; then
		lvcreate -L "$CONF_LOGICAL_USR_SIZE"G -n usr $CONF_VOL_GROUP_NAME
		if [ $? -ne 0 ] ; then
			report "lvcreate -L "$CONF_LOGICAL_USR_SIZE"G -n usr $CONF_VOL_GROUP_NAME"
			exit 1
		fi
	else
		lvcreate -L 20G -n usr $CONF_VOL_GROUP_NAME
		if [ $? -ne 0 ] ; then
			report "lvcreate -L 4G -n usr $CONF_VOL_GROUP_NAME"
			exit 1
		fi
	fi

#FORMAT VOLUMES

	eval $MKFAT /dev/"$CONF_ROOT_DEVICE"1
	if [ $? -ne 0 ] ; then
		report "[ERROR] mkfs.$CONF_FS_FORMAT /dev/$CONF_ROOT_DEVICE'1'"
		exit 1
	fi

	eval $MKEXT2 /dev/"$CONF_ROOT_DEVICE"2
	if [ $? -ne 0 ] ; then
		report "[ERROR] mkfs.ext2 /dev/$CONF_ROOT_DEVICE'2'"
		exit 1
	fi

	mkfs.$CONF_ROOTPART_FS /dev/mapper/"$CONF_VOL_GROUP_NAME"-root
        if [ $? -ne 0 ] ; then
		report "[ERROR] $MKFS /dev/mapper/"$CONF_VOL_GROUP_NAME"-root"
		exit 1
        fi

        mkfs.$CONF_ROOTPART_FS /dev/mapper/"$CONF_VOL_GROUP_NAME"-home
        if [ $? -ne 0 ] ; then
		report "[ERROR] $MKFS /dev/mapper/physix-home"
		exit 1
        fi

	mkfs.$CONF_ROOTPART_FS /dev/mapper/"$CONF_VOL_GROUP_NAME"-var
	if [ $? -ne 0 ] ; then
		report "[ERROR] $MKFS /dev/mapper/physix-var"
		exit 1
	fi

	mkfs.$CONF_ROOTPART_FS /dev/mapper/"$CONF_VOL_GROUP_NAME"-usr
	if [ $? -ne 0 ] ; then
		report "[ERROR] $MKFS /dev/mapper/physix-usr"
		exit 1
	fi
	

#MOUNT VOLUMES
	mkdir -p $BUILDROOT
	mount /dev/mapper/"$CONF_VOL_GROUP_NAME"-root $BUILDROOT
	if [ $? -ne 0 ] ; then
		report "[ERROR] mount /dev/mapper/"$CONF_VOL_GROUP_NAME"-root $BUILDROOT"
		exit 1
	fi

	mkdir -p $BUILDROOT/home
	mount /dev/mapper/"$CONF_VOL_GROUP_NAME"-home $BUILDROOT/home
	if [ $? -ne 0 ] ; then
		report "[ERROR] mount /dev/mapper/"$CONF_VOL_GROUP_NAME"-home $BUILDROOT/home"
		exit 1
	fi

	mkdir -p $BUILDROOT/var
	mount /dev/mapper/"$CONF_VOL_GROUP_NAME"-var $BUILDROOT/var
	if [ $? -ne 0 ] ; then
		report "[ERROR] mount /dev/mapper/"$CONF_VOL_GROUP_NAME"-var $BUILDROOT/var"
		exit 1
	fi

	mkdir -p $BUILDROOT/boot
	mount /dev/"$CONF_ROOT_DEVICE"2 $BUILDROOT/boot
	if [ $? -ne 0 ] ; then
		report "[ERROR] mount /dev/"$CONF_ROOT_DEVICE"2 $BUILDROOT/boot"
		exit 1
	fi

	mkdir -p $BUILDROOT/usr
	mount /dev/mapper/"$CONF_VOL_GROUP_NAME"-usr $BUILDROOT/usr
	if [ $? -ne 0 ] ; then
		report "[ERROR] mount /dev/mapper/physix-usr $BUILDROOT/usr"
		exit 1
	fi
}


function complete_setup() {

	mkdir -vp $BUILDROOT/var/physix/system-build-logs
	mkdir -vp $BUILDROOT/usr/src/physix/sources

	# TODO tighten these perms
	chmod 777 $BUILDROOT/system-build-logs
	mv -v /tmp/physix-init-host-build.log $BUILDROOT/var/physix/system-build-logs/build.log
	chmod 666 $BUILDROOT/system-build-logs/build.log

	echo "Downloading src-list.base"
	pull_sources ./src-list.base /mnt/physix/usr/src/physix/sources

	if [ "$CONF_UTILS" == "y" ] ; then
		pull_sources ./src-list.utils /mnt/physix/usr/src/physix/sources
	fi

	if [ "$CONF_DEVEL" == "y" ] ; then
		pull_sources ./src-list.devel /mnt/physix/usr/src/physix/sources
	fi

	if [ "$CONF_XORG"=="y" ] ; then
		pull_sources ./src-list.xorg /mnt/physix/usr/src/physix/sources/xc
	fi

	ln -sfv /usr/bin/bash /usr/bin/sh
	ln -sfv /usr/bin/gawk /usr/bin/awk

	if [ -e /tools ] ; then
		rm -rf /tools
	fi
	mkdir -v $BUILDROOT/tools
	ln -sfv $BUILDROOT/tools /

	grep -q physix /etc/passwd
	if [ $? -ne 0 ] ; then
		useradd -s /bin/bash -m physix 
	fi

	cp -r $PWD $BUILDROOT
	chmod 777 $BUILDROOT/physix

	cp -v $BUILDROOT/physix/configs/physix-bash-profile /home/physix/.bash_profile
	if [ $? -ne 0 ] ; then
		echo "Error Creating /home/physix/.bash_profile"
		exit 1
	fi
	cp -v $BUILDROOT/physix/configs/physix-bashrc /home/physix/.bashrc
	if [ $? -ne 0 ] ; then
		echo "Error Creating /home/physix/.bashrc"
		exit 1
	fi

	chown -v physix $BUILDROOT/tools
	chown -v physix $BUILDROOT/usr/src/physix/sources
}

function check_build_conf() {
        ERRORS=0
        for VAL in `cat ./build.conf | cut -d'=' -f2` ; do
                case "$VAL" in
                        hostname)
                                ERRORS=$((ERRORS+1))
                                ;;
                        /dev/SDX)
                                ERRORS=$((ERRORS+1))
                                ;;
                        /dev/SDYZ)
                                ERRORS=$((ERRORS+1))
                                ;;
                        w.x.y.z)
                                ERRORS=$((ERRORS+1))
                                ;;
			FORMAT)
				ERRORS=$((ERRORS+1))
				;;
                esac
        done

        if [ $ERRORS -ne 0 ] ; then
                echo "[ERROR] $ERRORS build.conf"
                exit 1
        fi
}

#####  MAIN  ######
#check_build_conf

verify_tools
if [ $? -eq 0 ] ; then
	echo "[ OK ] HOst tools verification"
else
	echo "[ FAIL ] HOst tools verification"
	exit 1
fi

if [ -e /dev/$CONF_ROOT_DEVICE ] ; then
	if [ "$CONF_USE_LVM" == "y" ] ; then
		init_storage_lvm
	fi
else
        echo "[ERROR] Could not find $CONF_ROOT_DEVICE"
        exit 1
fi

complete_setup

report "----------------------------------------"
report "- Disk Partitioning complete.          -"
report "- Next Steps:                          -"
report "-   1. cd /mnt/physix/physix           -"
report "-   2. Execute: ./1-build_toolchain.sh -"
report "----------------------------------------"

exit 0
