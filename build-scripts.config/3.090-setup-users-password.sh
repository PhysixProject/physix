#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

GUSER=`cat /physix/build.conf | grep GEN_USER | cut -d'=' -f2`

LOOP=0
while [ $LOOP -eq 0 ] ; do
	report "Set root Password"
	passwd root
	if [ $? -eq 0 ] ; then LOOP=1; fi
done


echo "build.conf specifys a general user to be created: $GUSER"
useradd -m $GUSER
chroot_check $? "useradd -m $GUSER"

LOOP=0
while [ $LOOP -eq 0 ] ; do
        passwd $GUSER
        if [ $? -eq 0 ] ; then LOOP=1; fi
done

useradd -m physix
chroot_check $? "useradd  physix"
LOOP=0
while [ $LOOP -eq 0 ] ; do
        passwd physix
        if [ $? -eq 0 ] ; then LOOP=1; fi
done

