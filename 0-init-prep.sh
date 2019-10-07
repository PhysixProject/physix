#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh

LFS='/mnt/lfs'
PHYSIX=`pwd`

# Used in md5_lookup
RTN=''

user=`whoami`
if [ $user != 'root' ] ; then
	echo "Must run this as user: root"
	echo "exiting..."
	exit 1
fi

# Call host system check


function setup_sources() {
	local ERROR=0
	mkdir -v /mnt/lfs/sources
	echo -e "\n\nDownloading Sources..."
	for pkg in `cat ./wget-list` ; do
		wget -q --continue --directory-prefix=$LFS/sources $pkg
		if [ $? -ne 0 ] ; then
			echo -e "\e[31m[ ERROR ]\e[0m $pkg"
			ERROR=1
		else
			echo -e "\e[92m[ OK ]\e[0m $pkg"
		fi
	done
	return $ERROR
}


# Fetch the expected md5sum of a source package.
function md5_lookup() {
	local FILE_NAME=$1
	local MD5SUM=''
	RTN=''
	for ENTRY in `cat ./md5sum.lst` ; do
		ENTRY_NAME=`echo $ENTRY | cut -d ',' -f1`
		MD5SUM=`echo $ENTRY | cut -d ',' -f2`
		if [ "$ENTRY_NAME" == "$FILE_NAME" ] ; then
			RTN=$MD5SUM
			return
		fi
	done
}

 
function md5_verify() {
	local SOURCES_DIR=$1
	local ERR=0

	echo -e "\n\nVerify Sources md5sums..."
	for FILE in `ls $SOURCES_DIR` ; do
		md5_lookup $FILE
		C=`md5sum $SOURCES_DIR/$FILE | cut -d' ' -f1`
		if [ "$RTN" == "$C" ] ; then
			echo -ne "\e[92m[ OK ]\e[0m "
		else
			echo -ne "\e[31m[ ERROR ]\e[0m "
			ERR=1
		fi
		echo  "$FILE: $C"
	done

	if [ $ERR -ne 0  ] ; then
		echo "[FAIL] CHECK YOUR SOURCES! At lease 1 package is not Authentic."
		exit 1
	fi
}


# format storage
# mount storage
function init_storage() {

	local DEVICE=$1
	local FSF=''

	mount | grep $DEVICE
	if [ $? -eq 0 ] ; then
		echo  "[ERROR] Device: $DEVICE already mounted, exit..."
		exit 1
	fi

	if [ ! -e /mnt/lfs ] ;  then
		echo "Creating mountpoint..."
		mkdir -v /mnt/lfs
	fi

	local FSF=`cat build.conf | grep FS_FORMAT | cut -d'=' -f2`
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
		sleep 5
		eval $MKFS $DEVICE
		if [ $? -ne 0 ] ; then 
			echo "[ERROR] Formatting $DEVICE" 
			exit 1
		fi
	else
		echo  "[ERROR] Aborting..."
		exit 1
	fi

	mount $DEVICE /mnt/lfs
	if [ $? -ne 0 ] ; then
		echo "[ERROR] mounting $DEVICE"
		exit 1
	fi	

}


function main() {

	setup_sources
	if [ $? -ne 0 ] ; then
		echo "[ERROR] One or more source packages have failed to downlowd. View the log"
		echo "messages above to determine which, and download it manually from another"
		echo "location. Place the source in /mnt/lfs/sources, and restart INSTALL.sh"
		exit 1
	fi

	md5_verify '/mnt/lfs/sources'

	ln -sfv /usr/bin/bash /usr/bin/sh
	ln -sfv /usr/bin/gawk /usr/bin/awk

	mkdir -v $LFS/tools
	ln -sfv $LFS/tools /

	groupadd lfs

	grep -q lfs /etc/passwd
	if [ $? -ne 0 ] ; then
		useradd -s /bin/bash -g lfs -m -k /dev/null lfs
	fi

	echo "Set passwd for user 'lfs' on host system:"
	passwd lfs

cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > /home/lfs/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF

	chown -v lfs $LFS/tools
	chown -v lfs $LFS/sources

	DPATH=$(dirname `pwd`)
	cp -r $PHYSIX $LFS
	chmod 777 $LFS/physix

	chown lfs:lfs $LFS/physix
	chown lfs:lfs $LFS/physix/system_scripts

	mkdir /mnt/lfs/system-build-logs
	chmod 777 /mnt/lfs/system-build-logs
	touch /mnt/lfs/system-build-logs/build.log
	chmod 666 /mnt/lfs/system-build-logs/build.log
}

function usage() {
	echo "usage statement"
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

TEMP=`getopt -o s::d::h::v:: -n '0-init-prep.sh' -- "$@"`
eval set -- "$TEMP"
if [ $? -ne 0 ] ; then
        usage
        exit 1
fi

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -h)
                usage
                exit 0
                ;;

        -v)
                echo "Verstion: $VERSION"
                exit 0
                ;;

	-d)
		D=`cat build.conf | grep ROOT_PARTITION | cut -d'=' -f2`
		if [ -e /dev/$D ] ; then
			init_storage "/dev/$D"
		else
			echo "[ERROR] Could not find $D"
			exit 1
		fi
		exit 0
		;;
	-s)
		main
		exit 0
		;;

        --) shift ; break ;;
        *) usage ; exit 1 ;;
    esac
done




