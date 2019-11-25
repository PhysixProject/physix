#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh

TOOLCHAINLOGS=$BUILDROOT/system-build-logs

IAM=`whoami`
if [ $IAM != "root" ] ; then
	echo "Must run script as root."
	exit 1
fi

CWD=`pwd`
if [ ! $CWD == "$BUILDROOT/physix" ] ; then
        echo "Must run from $BUILDROOT/physix"
        exit 1
fi

echo "--------------------------"
echo "- Building Toolchain...   "
echo "--------------------------"

START_POINT=${1:-0}
STOP_POINT=`wc -l ./1-build_toolchain.csv | cut -d' ' -f1`
BUILD_ID=0
for LINE in `cat ./1-build_toolchain.csv` ; do
	SCRIPT=$(echo $LINE | cut -d',' -f1)
	PKG0=$(echo $LINE | cut -d',' -f2)
	PKG1=$(echo $LINE | cut -d',' -f3)
	PKG2=$(echo $LINE | cut -d',' -f4)
	PKG3=$(echo $LINE | cut -d',' -f5)

        TIME=`date "+%D %T"`
        echo "$TIME : $BUILD_ID : Building $SCRIPT"

	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then
		su physix -c "./build-scripts.toolchain/$SCRIPT $PKG0 $PKG1 $PKG2 $PKG3" &> $TOOLCHAINLOGS/$SCRIPT
		check $? "$SCRIPT"
		echo ''
	fi
	BUILD_ID=$((BUILD_ID+1))
done 

./build-scripts.toolchain/1.370-chown.sh
check $? "1.370-chown.sh"

exit 0

