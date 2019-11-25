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

echo "---------------------------------"
echo "- Building Development tools... -"
echo "---------------------------------"

START_POINT=${1:-0}
STOP_POINT=`wc -l ./5-build-devel.csv | cut -d' ' -f1`

BUILD_ID=0
for LINE in `cat ./5-build-devel.csv | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
	IO=$(echo $LINE | cut -d',' -f1)
	SCRIPT=$(echo $LINE | cut -d',' -f2)
	PKG0=$(echo $LINE | cut -d',' -f3)
        PKG1=$(echo $LINE | cut -d',' -f4)
        PKG2=$(echo $LINE | cut -d',' -f5)

	TIME=`date "+%D %T"`
	echo "$TIME : $BUILD_ID : Building $PKG0"

	if [ "$IO" == "log" ] ; then
	        IO_DIRECTION="&> /system-build-logs/$SCRIPT"     
	else                                                     
		IO_DIRECTION="| tee /system-build-logs/$SCRIPT"  
	fi                                                       

	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then
		eval "/physix/build-scripts.devel/$SCRIPT $PKG0 $PKG1 $PKG2 $IO_DIRECTION"
		check $? "$SCRIPT"
		echo ''
	fi
	BUILD_ID=$((BUILD_ID+1))
done

exit 0



