#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh

iuser=`whoami`
if [ $iuser != 'root' ] ; then
    error "Must run this as user: root. Exiting"
    exit 1
fi

report "---------------------------------"
report "- Building Xorg...              -"
report "---------------------------------"

START_POINT=${1:-0}
STOP_POINT=`wc -l ./6-build-xorg.csv | cut -d' ' -f1`

BUILD_ID=0
for LINE in `cat ./6-build-xorg.csv | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
	IO=$(echo $LINE | cut -d',' -f1)
	SCRIPT=$(echo $LINE | cut -d',' -f2)
	PKG0=$(echo $LINE | cut -d',' -f3)
        PKG1=$(echo $LINE | cut -d',' -f4)
        PKG2=$(echo $LINE | cut -d',' -f5)

	local TIME=`date "+%Y-%m-%d-%T"`
	if [ "$IO" == "log" ] ; then
	        IO_DIRECTION="&> /var/physix/system-build-logs/$SCRIPT-$TIME"
	else
		IO_DIRECTION="| tee /var/physix/system-build-logs/$SCRIPT-$TIME"
	fi

	TIME=`date "+%D-%T"`
	report "$TIME : $BUILD_ID/$NUM_SCRIPTS : Building $SCRIPT"

	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then
		eval "/physix/build-scripts.xorg/$SCRIPT $PKG0 $PKG1 $PKG2 $IO_DIRECTION"
		check $? "$SCRIPT"
		echo ''
	fi
	BUILD_ID=$((BUILD_ID+1))
done

exit 0



