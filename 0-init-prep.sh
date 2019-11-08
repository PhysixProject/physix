#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh

PHYSIX=`pwd`

# Used in md5_lookup
RTN=''

user=`whoami`
if [ $user != 'root' ] ; then
	echo "Must run this as user: root"
	echo "exiting..."
	exit 1
fi

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

	if [ ! -e $BUILDROOT ] ;  then
		echo "Creating mountpoint..."
		mkdir -v $BUILDROOT
	fi

	local FSF=`cat build.conf | grep FS_FORMAT | cut -d'=' -f2`
	local MKFS=`which mkfs.$FSF` 
	if [ ! -e $MKFS ] ; then
		echo "mkfs.$FSF NOT FOUND. exiting..."
		exit 1
	fi

	local LSBLK=`which lsblk`
	if [ -e $LSBLK ] ; then eval $LSBLK; fi	

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
		echo  "[ERROR] Aborting..."
		exit 1
	fi

	mount $DEVICE $BUILDROOT
	if [ $? -ne 0 ] ; then
		echo "[ERROR] mounting $DEVICE"
		exit 1
	fi	

}


function main() {

	echo "Downloading src-list.base"                                      
	pull_sources ./src-list.base $BUILDROOT/sources                       
	#verify_md5list "$BUILDROOT/sources" md5sum-list.base                  
                                                                      
	CONF_UTILS=`cat /physix/build.conf | grep CONF_UTILS | cut -d'=' -f2` 
	if [ "$CONF_UTILS" == "y" ] ; then                                    
	        pull_sources ./src-list.utils $BUILDROOT/sources              
		#verify_md5list "$BUILDROOT/sources" md5sum-list.utils         
	fi                                                                    
                                                                      
	CONF_DEVEL=`cat /physix/build.conf | grep CONF_DEVEL | cut -d'=' -f2` 
	if [ "$CONF_DEVEL" == "y" ] ; then                                    
		pull_sources ./src-list.devel $BUILDROOT/sources              
		#verify_md5list "$BUILDROOT/sources" md5sum-list.devel         
	fi                                                                    


	ln -sfv /usr/bin/bash /usr/bin/sh
	ln -sfv /usr/bin/gawk /usr/bin/awk

	mkdir -v $BUILDROOT/tools
	ln -sfv $BUILDROOT/tools /

	groupadd physix

	grep -q physix /etc/passwd
	if [ $? -ne 0 ] ; then
		useradd -s /bin/bash -g physix -m -k /dev/null physix
	fi

	echo "Set passwd for user 'physix' on host system:"
	passwd physix

cat > /home/physix/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > /home/physix/.bashrc << "EOF"
set +h
umask 022
BUILDROOT=$BUILDROOT
LC_ALL=POSIX
BUILDROOT_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF

	chown -v physix $BUILDROOT/tools
	chown -v physix $BUILDROOT/sources

	DPATH=$(dirname `pwd`)
	cp -r $PHYSIX $BUILDROOT
	chmod 777 $BUILDROOT/physix

	chown physix:physix $BUILDROOT/physix
	chown physix:physix $BUILDROOT/physix/system_scripts

	mkdir $BUILDROOT/system-build-logs
	chmod 777 $BUILDROOT/system-build-logs
	touch $BUILDROOT/system-build-logs/build.log
	chmod 666 $BUILDROOT/system-build-logs/build.log
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




