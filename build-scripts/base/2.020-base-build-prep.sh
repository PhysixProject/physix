#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source $BUILDROOT/physix/include.sh || exit 1

#SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
#source $SCRIPTPATH/../include.sh

mkdir -pv $BUILDROOT/{dev,proc,sys,run}
check $? "6.02-prep mkdir -pv $BUILDROOT/{dev,proc,sys,run}"

if [ ! -e $BUILDROOT/dev/console ] ; then
	mknod -m 600 $BUILDROOT/dev/console c 5 1
	check $? "2.020-base-build-prep: mknod -m 600 $BUILDROOT/dev/console c 5 1"
fi

if [ ! -e $BUILDROOT/dev/null ] ; then
	mknod -m 666 $BUILDROOT/dev/null c 1 3
	check $? "2.020-base-build-prep: mknod -m 666 $BUILDROOT/dev/null c 1 3"
fi

mount | grep "$BUILDROOT/dev"
if [ $? -ne 0 ] ; then
	mount -v --bind /dev $BUILDROOT/dev
	check $? "2.020-base-build-prep: mount -v --bind /dev $BUILDROOT/dev"
fi

mount | grep "$BUILDROOT/dev/pts"
if [ $? -ne 0 ] ; then
	mount -vt devpts devpts $BUILDROOT/dev/pts -o gid=5,mode=620
	check $? "2.020-base-build-prep: mount -vt devpts devpts $BUILDROOT/dev/pts"
fi

mount | grep "$BUILDROOT/proc"
if [ $? -ne 0 ] ; then
	mount -vt proc proc $BUILDROOT/proc
	check $? "2.020-base-build-prep: mount -vt proc proc $BUILDROOT/proc"
fi

mount | grep "$BUILDROOT/sys"
if [ $? -ne 0 ] ; then
	mount -vt sysfs sysfs $BUILDROOT/sys
	check $? "2.020-base-build-prep: mount -vt sysfs sysfs $BUILDROOT/sys"
fi

mount | grep "$BUILDROOT/run"
if [ $? -ne 0 ] ; then
	mount -vt tmpfs tmpfs $BUILDROOT/run
	check $? "2.020-base-build-prep: mount -vt tmpfs tmpfs $BUILDROOT/run"
fi

if [ -h $BUILDROOT/dev/shm ]; then
  mkdir -pv $BUILDROOT/$(readlink $BUILDROOT/dev/shm)
  check $? "2.020-base-build-prep: mkdir -pv $BUILDROOT/$(readlink $BUILDROOT/dev/shm)"
fi

