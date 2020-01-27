#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh
source ./build.conf

iuser=`whoami`
if [ $iuser != 'root' ] ; then
    error "Must run this as user: root"
    exit 1
fi

report "---------------------------------"
report "- Building Tests... -"
report "---------------------------------"

START_POINT=${1:-0}
STOP_POINT=`wc -l ./6-build-devel.csv | cut -d' ' -f1`

BUILD_ID=0
for LINE in `cat ./6-build-tests.csv | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
	IO=$(echo $LINE | cut -d',' -f1)
	SCRIPT=$(echo $LINE | cut -d',' -f2)
	PKG0=$(echo $LINE | cut -d',' -f3)
        PKG1=$(echo $LINE | cut -d',' -f4)
        PKG2=$(echo $LINE | cut -d',' -f5)

	TIME=`date "+%D %T"`
	report "$TIME : $BUILD_ID : Building $PKG0"

	if [ "$IO" == "log" ] ; then
	        IO_DIRECTION="&> /system-build-logs/$SCRIPT"     
	else                                                     
		IO_DIRECTION="| tee /system-build-logs/$SCRIPT"  
	fi                                                       

	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then

		if [ $PKG0 ] ; then
		        # physix doesn't exist as a user
		        unpack $PKG0 "physix:root"
		        check $? "Unpack $PKG0"
		        return_src_dir $PKG0
		        SRC0=$SRC_DIR
		fi

		if [ ! -e /physix/build-scripts.tests/$SCRIPT ] ; then
			report "Build Script NOT found: /build-scripts.utils/$SCRIPT"
			exit 1
		fi

		eval "/physix/build-scripts.tests/$SCRIPT $PKG0 $PKG1 $PKG2 $IO_DIRECTION"
		check $? "$SCRIPT"
		echo ''

		if [ "$CONF_BUILD_SMALL" == "y" ] && [ $SRC0 ] ; then
			cd /sources && rm -rf ./$SRC0
		fi
	fi
	BUILD_ID=$((BUILD_ID+1))
done

exit 0



