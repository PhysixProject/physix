#!/bin/bash                         
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh

IAM=`whoami`
if [ "$IAM" != "root" ] ; then
    echo "Must run this as user: root"
    echo "exiting..."
    exit 1
fi

CWD=`pwd`
if [ "$CWD" != "$BUILDROOT/physix" ] ; then
	echo "[ERROR] must run from $BUILDROOT/physix, exiting..."
	exit 1
fi

report "---------------------------"
report "- Building Base System... -"
report "---------------------------"

START_POINT=${1:-0}
STOP_POINT=`wc -l ./2-build-base-sys.csv | cut -d' ' -f1`

# Called differently becuase it is not chrooted
BUILD_ID=0
TIME=`date "+%D %T"`
report "$TIME : $BUILD_ID : Building 6.02-prep.sh"
if [ $START_POINT -eq 0 ] ; then
	./build-scripts.base/2.020-base-build-prep.sh
	check $? "2.020-base-build-prep"
fi

BUILD_ID=$((BUILD_ID+1))
for LINE in `cat ./2-build-base-sys.csv` ; do
	SCRIPT=$(echo $LINE | cut -d',' -f1)
	PKG0=$(echo $LINE | cut -d',' -f2)
	PKG1=$(echo $LINE | cut -d',' -f3)

	TIME=`date "+%D %T"`
	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then
		report "$TIME : $BUILD_ID : Building $SCRIPT $PKG0 $PKG1"
		chroot-build '/physix/build-scripts.base' $SCRIPT $PKG0 $PKG1
		check $? "$SCRIPT"
		echo ''
	fi
	BUILD_ID=$((BUILD_ID+1))
done 

exit 0

