#!/bin/bash                         
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /mnt/lfs/physix/include.sh

IAM=`whoami`
if [ "$IAM" != "root" ] ; then
    echo "Must run this as user: root"
    echo "exiting..."
    exit 1
fi

CWD=`pwd`
if [ "$CWD" != "/mnt/lfs/physix" ] ; then
	echo "[ERROR] must run from /mnt/lfs/physix, exiting..."
	exit 1
fi

echo "Building Base System..."

START_POINT=${1:-0}
STOP_POINT=`wc -l ./2-build-base-sys.csv | cut -d' ' -f1`

# Called differently becuase it is not chrooted
BUILD_ID=0
TIME=`date "+%D %T"`
echo "$TIME : $BUILD_ID : Building 6.02-prep.sh"
./system_scripts/6.02-prep.sh
check $? "6.02-prep"

BUILD_ID=$((BUILD_ID+1))
for LINE in `cat ./2-build-base-sys.csv` ; do
	SCRIPT=$(echo $LINE | cut -d',' -f1)
	PKG0=$(echo $LINE | cut -d',' -f2)
	PKG1=$(echo $LINE | cut -d',' -f3)

	TIME=`date "+%D %T"`
	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then
		echo "$TIME : $BUILD_ID : Building $SCRIPT"
		chroot-build '/physix/system_scripts' $SCRIPT $PKG0 $PKG1
		check $? "$SCRIPT"
		echo ''
	fi
	BUILD_ID=$((BUILD_ID+1))
done 

exit 0

