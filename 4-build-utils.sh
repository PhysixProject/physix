#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh

iuser=`whoami`
if [ $iuser != 'root' ] ; then
    echo "Must run this as user: root"
    echo "exiting..."
    exit 1
fi

echo "Building Misc Tools..."

START_POINT=${1:-0}
STOP_POINT=`wc -l ./4-build-utils.csv | cut -d' ' -f1`

BUILD_ID=0
for LINE in `cat ./4-build-utils.csv | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
	IO=$(echo $LINE | cut -d',' -f1)
	SCRIPT=$(echo $LINE | cut -d',' -f2)
	PKG=$(echo $LINE | cut -d',' -f3)

	TIME=`date "+%D %T"`
	echo "$TIME : $BUILD_ID : Building $PKG"

	if [ "$IO" == "log" ] ; then
	        IO_DIRECTION="&> /system-build-logs/$SCRIPT"     
	else                                                     
		IO_DIRECTION="| tee /system-build-logs/$SCRIPT"  
	fi                                                       

	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then
		eval "/physix/build-scripts.utils/$SCRIPT $PKG $IO_DIRECTION"
		check $? "$SCRIPT"
		echo ''
	fi
	BUILD_ID=$((BUILD_ID+1))
done

exit 0



