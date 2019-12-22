#!/bin/bash                         
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh
source ./build.conf

IAM=`whoami`                            
if [ "$IAM" != "root" ] ; then          
    error "Must run this as user: root" 
    exit 1                              
fi                                      


echo "------------------------------"
echo "- Configuring Base System... -"
echo "------------------------------"

START_POINT=${1:-0}
STOP_POINT=`wc -l ./3-config-base-sys.csv | cut -d' ' -f1`

BUILD_ID=0
for LINE in `cat ./3-config-base-sys.csv | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
	IO=$(echo $LINE | cut -d',' -f1)
	SCRIPT=$(echo $LINE | cut -d',' -f2)
	PKG=$(echo $LINE | cut -d',' -f3)

	TIME=`date "+%D %T"`
	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then
                                                                
		if [ $PKG ] ; then
			unpack $PKG "physix:root" NCHRT
			check $? "Unpack $PKG"
			return_src_dir $PKG "NCHRT"
			SRC0=$SRC_DIR
		fi
                                                                
		if [ ! -e $BUILDROOT/physix/build-scripts.config/$SCRIPT ] ; then
			report "Build Script NOT found: /build-scripts.config/$SCRIPT"
			exit 1
		fi

		report "$TIME : $BUILD_ID : Building $SCRIPT"
		chroot-conf-build '/physix/build-scripts.config' $SCRIPT $SRC0 $IO
		check $? "$SCRIPT"
		echo ''

		#if [ "$CONF_BUILD_SMALL" == "y" ] ; then
		#       return_src_dir $PKG NCHRT
		#       rm -rf $BUILDROOT/sources/$SRC_DIR
		#fi
	fi

	BUILD_ID=$((BUILD_ID+1))

done

echo "------------------------------"
echo "- Base System Configured     -"
echo "------------------------------"

exit 0



