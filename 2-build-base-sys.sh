#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh
source ./build.conf

IAM=`whoami`
if [ "$IAM" != "root" ] ; then
    error "Must run this as user: root"
    exit 1
fi

CWD=`pwd`
if [ "$CWD" != "$BUILDROOT/physix" ] ; then
	error "Must run from $BUILDROOT/physix, exiting..."
	exit 1
fi


report "---------------------------"
report "- Building Base System... -"
report "---------------------------"

START_POINT=${1:-0}
STOP_POINT=`wc -l ./2-build-base-sys.csv | cut -d' ' -f1`
NUM_SCRIPTS=`ls $BUILDROOT/physix/build-scripts.base/ | wc -l`
BUILD_ID=0
TIME=`date "+%D-%T"`
report "$TIME : $BUILD_ID : Building 2.020-base-build-prep.sh"

# Called differently becuase it is not chrooted
if [ $START_POINT -eq 0 ] ; then
	report "Running: 2.02.-base-build-prep.sh"
	./build-scripts.base/2.020-base-build-prep.sh
	check $? "2.020-base-build-prep.sh"
fi

BUILD_ID=$((BUILD_ID+1))
for LINE in `cat ./2-build-base-sys.csv | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
	SCRIPT=$(echo $LINE | cut -d',' -f1)
	PKG0=$(echo $LINE | cut -d',' -f2)
	PKG1=$(echo $LINE | cut -d',' -f3)

	TIME=`date "+%D-%T"`
	report "$TIME : $BUILD_ID/$NUM_SCRIPTS : Building $SCRIPT"

	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then

		if [ $PKG1 ] ; then
			unpack $PKG1 "physix:root" NCHRT
			check $? "Unpack $PKG1"
			return_src_dir $PKG1 "NCHRT"
			SRC1=$SRC_DIR
		fi

		if [ $PKG0 ] ; then
			unpack $PKG0 "physix:root" NCHRT
			check $? "Unpack $PKG0"
			return_src_dir $PKG0 "NCHRT"
			SRC0=$SRC_DIR
		fi

		if [ ! -e $BUILDROOT/physix/build-scripts.base/$SCRIPT ] ; then
			report "File not found: /build-scripts.base/$SCRIPT"
			exit 1
		fi

		chroot-build '/physix/build-scripts.base' $SCRIPT $SRC0 $SRC1
		check $? "$SCRIPT"
		echo ''

		if [ "$CONF_BUILD_SMALL" == "y" ] && [ $SRC0 ] ; then
		       cd $BUILDROOT/usr/src/physix/sources/ && rm -rf ./$SRC0
		fi

	fi

	BUILD_ID=$((BUILD_ID+1))

done

report "--------------------------------------"
report "- Base System Build Complete!        -"
report "- Next Step:                         -"
report "-   Execute: ./3-config-base-sys.sh  -"
report "--------------------------------------"

exit 0

