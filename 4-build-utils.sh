#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh
source ./build.conf

chmod -R physix:physix /usr/src/physix/sources

iuser=`whoami`
if [ $iuser != 'root' ] ; then
    error "Must run this as user: root. Exiting..."
    exit 1
fi

report "--------------------------"
report "- Building Utilities...  -"
report "--------------------------"

START_POINT=${1:-0}
STOP_POINT=`wc -l ./4-build-utils.csv | cut -d' ' -f1`

BUILD_ID=0
for LINE in `cat ./4-build-utils.csv | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
	IO=$(echo $LINE | cut -d',' -f1)
	SCRIPT=$(echo $LINE | cut -d',' -f2)
	PKG=$(echo $LINE | cut -d',' -f3)

	if [ "$IO" == "log" ] ; then
	        IO_DIRECTION="&> /var/physix/system-build-logs/$SCRIPT"
	else
		IO_DIRECTION="| tee /var/physix/system-build-logs/$SCRIPT"
	fi

	TIME=`date "+%D-%T"`
	report "$TIME : $BUILD_ID : Building $PKG"
	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then

		if [ $PKG ] ; then
			# physix doesn't exist as a user
			unpack $PKG "physix:root"
			check $? "Unpack $PKG"
			return_src_dir $PKG
			SRC0=$SRC_DIR
		fi

		if [ ! -e /physix/build-scripts.utils/$SCRIPT ] ; then
			report "Build Script NOT found: /build-scripts.utils/$SCRIPT"
			exit 1
		fi

		eval "/physix/build-scripts.utils/$SCRIPT $SRC0 $IO_DIRECTION"
		check $? "$SCRIPT"
		echo ''

		if [ "$CONF_BUILD_SMALL" == "y" ] ; then
			cd /usr/src/physix/sources && rm -rf ./$SRC0
		fi
	fi
	BUILD_ID=$((BUILD_ID+1))
done

report "-----------------------------"
report "- Utilities Build Complete  -"
report "-----------------------------"

exit 0



