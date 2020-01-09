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




# format storage
# mount storage
function init_storage_lvm() {

        X=`ls /dev/ | grep $CONF_ROOT_DEVICE | wc -l`
        Y=$(($X-1))
        echo "Found $Y partitions on /dev/$CONF_ROOT_DEVICE"
        if [ $y -ne 0 ] ; then
                lsblk -f
                echo "Please remove all Partitions on /dev/$CONF_ROOT_DEVICE"
                echo "Exiting..."
                exit 1
        fi

        report "Creating Partitions"
	/sbin/parted /dev/sda parted /dev/sda mklabel msdos 1
        /sbin/parted /dev/sda mkpart primary 1 1024
        if [ $? -ne 0 ] ; then
                report "[ERROR] create primary 1 1024"
                exit 1
        fi

        /sbin/parted /dev/sda mkpart primary 1024 2025
        if [ $? -ne 0 ] ; then
                report "[ERROR] create primary 1024 2025"
                exit 1
        fi

        /sbin/parted /dev/sda mkpart primary 2025 497000
        if [ $? -ne 0 ] ; then
                report "[ERROR] create primary 2025 497000"
                exit 1
        fi

        /sbin/parted /dev/sda set 1 boot on
        if [ $? -ne 0 ] ; then
                report "[ERROR] parted /dev/sda set 1 boot on"
                exit 1
        fi

        /sbin/mkfs.ext2  /dev/"$CONF_ROOT_DEVICE"1
        if [ $? -ne 0 ] ; then
                report "[ERROR] mkfs.fat  /dev/$CONF_ROOT_DEVICE'1'"
                exit 1
        fi

        /sbin/mkfs.ext2 /dev/"$CONF_ROOT_DEVICE"2
        if [ $? -ne 0 ] ; then
                report "[ERROR] mkfs.ext2 /dev/$CONF_ROOT_DEVICE'2'"
                exit 1
        fi

        pvcreate -ff /dev/"$CONF_ROOT_DEVICE"3
        if [ $? -ne 0 ] ; then
                report "[ERROR] Createing Physical Volume $CONF_ROOT_DEVICE'3'. exiting..."
                exit 1
        fi

        vgcreate physix /dev/"$CONF_ROOT_DEVICE"3
        if [ $? -ne 0 ] ; then
                report "[ERROR] vgcreate physix /dev/$CONF_ROOT_DEVICE'3'"
                exit 1
        fi

        lvcreate -L 100G -n root physix
        if [ $? -ne 0 ] ; then
                report "[ERROR] lvcreate -L 100G -n root physix"
                exit 1
        fi

        lvcreate -L 150G -n home physix
        if [ $? -ne 0 ] ; then
                report "[ERROR] lvcreate -L 150G -n home physix"
                exit 1
        fi

        mkfs.ext4 /dev/mapper/physix-root
        if [ $? -ne 0 ] ; then
                report "[ERROR] mkfs.ext4 /dev/mapper/physix-root"
                exit 1
        fi

        mkfs.ext4 /dev/mapper/physix-home
        if [ $? -ne 0 ] ; then
                report "[ERROR] mkfs.ext4 /dev/mapper/physix-home"
                exit 1
        fi

        mkdir -p $BUILDROOT
        mount /dev/mapper/physix-root $BUILDROOT
        if [ $? -ne 0 ] ; then
                report "[ERROR] mounting $DEVICE"
                exit 1
        fi

        mkdir -p $BUILDROOT/home
        mount /dev/mapper/physix-home $BUILDROOT/home
        if [ $? -ne 0 ] ; then
                report "[ERROR] mounting $BUILDROOT/home"
                exit 1
        fi

        mkdir -p $BUILDROOT/boot
        mount /dev/sda2 $BUILDROOT/boot
        if [ $? -ne 0 ] ; then
                report "[ERROR] mounting $BUILDROOT/boot"
                exit 1
        fi

        #mkdir -p $BUILDROOT/boot/efi
        #mount /dev/sda1 $BUILDROOT/boot/efi
        #if [ $? -ne 0 ] ; then
        #        report "[ERROR] mounting $BUILDROOT/boot/efi"
        #        exit 1
        #fi

}




# format storage
# mount storage
function init_storage_efi() {

	X=`ls /dev/ | grep $CONF_ROOT_DEVICE | wc -l`
	Y=$(($X-1))
	echo "Found $Y partitions on /dev/$CONF_ROOT_DEVICE"
	if [ $y -ne 0 ] ; then
		lsblk -f
		echo "Please remove all Partitions on /dev/$CONF_ROOT_DEVICE"
		echo "Exiting..."
		exit 1
	fi

	report "Creating Partitions"
	/sbin/parted /dev/sda mkpart primary 1 1024
	if [ $? -ne 0 ] ; then
		report "[ERROR] create primary 1 1024"
		exit 1
	fi

	/sbin/parted /dev/sda mkpart primary 1024 2025
	if [ $? -ne 0 ] ; then
		report "[ERROR] create primary 1024 2025"
		exit 1
	fi

	/sbin/parted /dev/sda mkpart primary 2025 497000
	if [ $? -ne 0 ] ; then
		report "[ERROR] create primary 2025 497000"
		exit 1
	fi

	/sbin/parted /dev/sda set 1 boot on
	if [ $? -ne 0 ] ; then
		report "[ERROR] parted /dev/sda set 1 boot on"
		exit 1
	fi

	/sbin/mkfs.fat  /dev/"$CONF_ROOT_DEVICE"1 
	if [ $? -ne 0 ] ; then
		report "[ERROR] mkfs.fat  /dev/$CONF_ROOT_DEVICE'1'"
		exit 1
	fi

	/sbin/mkfs.ext2 /dev/"$CONF_ROOT_DEVICE"2
	if [ $? -ne 0 ] ; then
		report "[ERROR] mkfs.ext2 /dev/$CONF_ROOT_DEVICE'2'"
		exit 1
	fi

	pvcreate -ff /dev/"$CONF_ROOT_DEVICE"3
	if [ $? -ne 0 ] ; then
		report "[ERROR] Createing Physical Volume $CONF_ROOT_DEVICE'3'. exiting..."
		exit 1
	fi

	vgcreate physix /dev/"$CONF_ROOT_DEVICE"3
	if [ $? -ne 0 ] ; then
		report "[ERROR] vgcreate physix /dev/$CONF_ROOT_DEVICE'3'"
		exit 1
	fi

	lvcreate -L 100G -n root physix
	if [ $? -ne 0 ] ; then
		report "[ERROR] lvcreate -L 100G -n root physix"
		exit 1
	fi

	lvcreate -L 150G -n home physix
	if [ $? -ne 0 ] ; then
		report "[ERROR] lvcreate -L 150G -n home physix"
		exit 1
	fi
		
	mkfs.ext4 /dev/mapper/physix-root
	if [ $? -ne 0 ] ; then
		report "[ERROR] mkfs.ext4 /dev/mapper/physix-root"
		exit 1
	fi

	mkfs.ext4 /dev/mapper/physix-home
	if [ $? -ne 0 ] ; then
		report "[ERROR] mkfs.ext4 /dev/mapper/physix-home"
		exit 1
	fi

	mkdir -p $BUILDROOT
	mount /dev/mapper/physix-root $BUILDROOT
	if [ $? -ne 0 ] ; then
		report "[ERROR] mounting $DEVICE"
		exit 1
	fi 

	mkdir -p $BUILDROOT/home
	mount /dev/mapper/physix-home $BUILDROOT/home
	if [ $? -ne 0 ] ; then
		report "[ERROR] mounting $BUILDROOT/home"
		exit 1
	fi

	mkdir -p $BUILDROOT/boot
	mount /dev/sda2 $BUILDROOT/boot
	if [ $? -ne 0 ] ; then
		report "[ERROR] mounting $BUILDROOT/boot"
		exit 1
	fi

	mkdir -p $BUILDROOT/boot/efi
	mount /dev/sda1 $BUILDROOT/boot/efi
	if [ $? -ne 0 ] ; then
		report "[ERROR] mounting $BUILDROOT/boot/efi"
		exit 1
	fi

}


function init_storage_std() {

	local DEVICE=$1
	local FSF=''

	mount | grep $DEVICE
	if [ $? -eq 0 ] ; then
		echo "[ERROR] Device: $DEVICE already mounted, exit..."
		exit 1
	fi

	if [ ! -e $BUILDROOT ] ;  then
		echo "Creating mountpoint..."
		mkdir -v $BUILDROOT
	fi

	local FSF=`cat build.conf | grep CONF_FS_FORMAT | cut -d'=' -f2`
	local MKFS=`which mkfs.$FSF` 
	if [ ! -e $MKFS ] ; then
		echo "mkfs.$FSF NOT FOUND. exiting..."
		exit 1
	fi

	local LSBLK=`which lsblk`
	if [ -e $LSBLK ] ; then eval $LSBLK; fi	

	echo -e "\n\n--------------------------------------------------------------"
	echo "You have requested to install to $DEVICE"
	echo "build.conf specifies $FSF as the desired File System Format"
	echo "This will format/Erase ALL Data on $DEVICE"
	echo -n "Continue? (yes/no):"
	read RESP
	if [ $RESP == "yes" ] ; then
		echo "Formatting $DEVICE..."
		eval $MKFS $DEVICE
		if [ $? -ne 0 ] ; then 
			echo "[ERROR] Formatting $DEVICE" 
			exit 1
		fi
	else
		echo "[ERROR] Aborting..."
		exit 1
	fi

	mount $DEVICE $BUILDROOT
	if [ $? -ne 0 ] ; then
		echo "[ERROR] mounting $DEVICE"
		exit 1
	fi	
	
}


function complete_setup() {

	mkdir $BUILDROOT/system-build-logs
	chmod 777 $BUILDROOT/system-build-logs
	mv /tmp/physix-init-host-build.log $BUILDROOT/system-build-logs/build.log
	chmod 666 $BUILDROOT/system-build-logs/build.log

	echo "Downloading src-list.base"
	pull_sources ./src-list.base $BUILDROOT/sources

	CONF_UTILS=`cat ./build.conf | grep CONF_UTILS | cut -d'=' -f2`
	if [ "$CONF_UTILS" == "y" ] ; then
		pull_sources ./src-list.utils $BUILDROOT/sources
	fi

	CONF_DEVEL=`cat ./build.conf | grep CONF_DEVEL | cut -d'=' -f2`
	if [ "$CONF_DEVEL" == "y" ] ; then
		pull_sources ./src-list.devel $BUILDROOT/sources
	fi

	ln -sfv /usr/bin/bash /usr/bin/sh
	ln -sfv /usr/bin/gawk /usr/bin/awk

	if [ -e /tools ] ; then
		rm -rf /tools
	fi
	mkdir -v $BUILDROOT/tools
	ln -sfv $BUILDROOT/tools /

	groupadd physix

	grep -q physix /etc/passwd
	if [ $? -ne 0 ] ; then
		useradd -s /bin/bash -g physix -m -k /dev/null physix
	fi


	LOOP=0
	while [ $LOOP -eq 0 ] ; do
		report "Please Set passwd for 'physix' user"
		passwd physix
		if [ $? -eq 0 ] ; then LOOP=1; fi
	done


	cp -v configs/physix-bash-profile /home/physix/.bash_profile
	if [ $? -ne 0 ] ; then
		echo "Error Creating /home/physix/.bash_profile"
		exit 1
	fi
	cp -v configs/physix-bashrc /home/physix/.bashrc
	if [ $? -ne 0 ] ; then
		echo "Error Creating /home/physix/.bashrc"
		exit 1
	fi

	chown -v physix $BUILDROOT/tools
	chown -v physix $BUILDROOT/sources

	DPATH=$(dirname `pwd`)
	cp -r $PWD $BUILDROOT
	chmod 777 $BUILDROOT/physix

	#chown physix:physix $BUILDROOT/physix
	#chown physix:physix $BUILDROOT/physix/build-scripts.base
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
check_build_conf

verify_tools
if [ $? -eq 0 ] ; then
	echo "[ OK ] HOst tools verification"
else
	echo "[ FAIL ] HOst tools verification"
	exit 1
fi

if [ -e /dev/$CONF_ROOT_DEVICE ] ; then
	if [ "$CONF_USE_LVM" == "y" ] ; then
		init_storage_lvm "/dev/$CONF_ROOT_DEVICE"
	fi
else
        echo "[ERROR] Could not find $CONF_ROOT_DEVICE"
        exit 1
fi

complete_setup

exit 0
