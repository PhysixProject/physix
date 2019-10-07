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
STOP_POINT=`wc -l ./4-build-misc.csv | cut -d' ' -f1`

BUILD_ID=0
for LINE in `cat ./4-build-misc.csv` ; do
	IO=$(echo $LINE | cut -d',' -f1)
        SCRIPT=$(echo $LINE | cut -d',' -f2)
	PKG=$(echo $LINE | cut -d',' -f3)

	TIME=`date "+%D %T"`
	echo "$TIME : $BUILD_ID : Building $PKG"

	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then
		chroot-conf-build '/physix/misc_scripts' $SCRIPT $PKG $IO
		check $? "$SCRIPT"
		echo ''
		BUILD_ID=$((BUILD_ID+1))
	fi
done

exit 0



