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

echo "Configuring Base System..."

START_POINT=${1:-0}
STOP_POINT=`wc -l ./3-config-base-sys.csv | cut -d' ' -f1`

BUILD_ID=0
for LINE in `cat ./3-config-base-sys.csv` ; do
	IO=$(echo $LINE | cut -d',' -f1)
        SCRIPT=$(echo $LINE | cut -d',' -f2)
	PKG0=$(echo $LINE | cut -d',' -f3)
	PKG1=$(echo $LINE | cut -d',' -f4) 

	TIME=`date "+%D %T"`
	if [ $BUILD_ID -ge $START_POINT ] && [ $BUILD_ID -le $STOP_POINT ] ; then
		echo "$TIME : $BUILD_ID : Building $SCRIPT"
		chroot-conf-build '/physix/build-scripts.config' $SCRIPT $PKG0 $PKG1 $IO
		check $? "$SCRIPT"
		echo ''
	fi
	BUILD_ID=$((BUILD_ID+1))
done

exit 0



