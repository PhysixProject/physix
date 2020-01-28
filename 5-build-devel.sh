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
report "- Building Development tools... -"
report "---------------------------------"

START_POINT=${1:-0}
STOP_POINT=`wc -l ./5-build-devel.csv | cut -d' ' -f1`
NUM_SCRIPTS=`ls /physix/build-scripts.devel/ | wc -l`
BUILD_ID=0
for LINE in `cat ./5-build-devel.csv | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
	IO=$(echo $LINE | cut -d',' -f1)
	SCRIPT=$(echo $LINE | cut -d',' -f2)
	PKG0=$(echo $LINE | cut -d',' -f3)
        PKG1=$(echo $LINE | cut -d',' -f4)
        PKG2=$(echo $LINE | cut -d',' -f5)

	TIME=`date "+%Y-%m-%d-%T "| tr ":" "-"`
	if [ "$IO" == "log" ] ; then
	        IO_DIRECTION="&> /var/physix/system-build-logs/$SCRIPT-$TIME"
	else
		IO_DIRECTION="| tee /var/physix/system-build-logs/$SCRIPT-$TIME"
	fi

	TIME=`date "+%D-%T"`
	report "$TIME : $BUILD_ID/$NUM_SCRIPTS : Building $PKG0"
	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then

		if [ $PKG2 ] ; then
			unpack $PKG2 "physix:root" 'FLAG'
			check $? "Unpack $PKG2"
			return_src_dir $PKG2
			SRC2=$SRC_DIR
		fi

		if [ $PKG1 ] ; then
			unpack $PKG1 "physix:root" 'FLAG'
			check $? "Unpack $PKG1"
			return_src_dir $PKG1
			SRC1=$SRC_DIR
		fi

		if [ $PKG0 ] ; then
			unpack $PKG0 "physix:root" 'FLAG'
			check $? "Unpack $PKG0"
			return_src_dir $PKG0
			SRC0=$SRC_DIR
		fi

		if [ ! -e /physix/build-scripts.devel/$SCRIPT ] ; then
			report "Build Script NOT found: /build-scripts.devel/$SCRIPT"
			exit 1
		fi

		eval "/physix/build-scripts.devel/$SCRIPT $SRC0 $PKG1 $PKG2 $IO_DIRECTION"
		check $? "$SCRIPT"
		echo ''

		if [ "$CONF_BUILD_SMALL" == "y" ] ; then
		       cd /usr/src/physix/sources/ && rm -rf ./$SRC0
		fi
	fi
	BUILD_ID=$((BUILD_ID+1))
done

report "-------------------------------------"
report "- Development tools build complete  -"
report "-------------------------------------"

exit 0

