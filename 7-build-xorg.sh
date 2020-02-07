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
STOP_POINT=`wc -l ./7-build-xorg.csv | cut -d' ' -f1`
NUM_SCRIPTS=`cat 7-build-xorg.csv | wc -l`
BUILD_ID=0
for LINE in `cat ./7-build-xorg.csv | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
	IO=$(echo $LINE | cut -d',' -f1)
	SCRIPT=$(echo $LINE | cut -d',' -f2)
	PKG0=$(echo $LINE | cut -d',' -f3)
        PKG1=$(echo $LINE | cut -d',' -f4)
        PKG2=$(echo $LINE | cut -d',' -f5)

	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then

        	if [ $PKG0 ] ; then
                	unpack $PKG0 "physix:root" 'FLAG' 'xc'
                	check $? "Unpack $PKG0"
                	return_src_dir $PKG0
                	echo "srcdir $SRC_DIR"
                	SRC0=$SRC_DIR
        	fi

		echo "$SCRIPT"
		echo "$PKG0"

		TIME=`date "+%Y-%m-%d-%T"| tr ":" "-"`
		if [ "$IO" == "log" ] ; then
		        IO_DIRECTION="&> /var/physix/system-build-logs/$TIME-$SCRIPT-$PKG0.log"
			#IO_DIRECTION="&> /var/physix/system-build-logs/$TIME-$SCRIPT-"
		else
		        IO_DIRECTION="| tee /var/physix/system-build-logs/$TIME-$SCRIPT-$PKG0.log"
		fi

		TIME=`date "+%D-%T"`
		report "$TIME : $BUILD_ID/$NUM_SCRIPTS : Building $PKG0 $SCRIPT"
		
		echo "/physix/build-scripts.xorg/$SCRIPT $SRC0"
		eval "/physix/build-scripts.xorg/$SCRIPT $SRC0 $PKG0 $PKG2 $IO_DIRECTION"
		check $? "Build Complete: $SRC0 : $SCRIPT"
		echo ''
	fi
	BUILD_ID=$((BUILD_ID+1))
done

exit 0

