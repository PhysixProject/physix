#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../include.sh

mkdir -pv $BUILDROOT/{dev,proc,sys,run}
check $? "2.020-base-build-prep.sh mkdir -pv $BUILDROOT/{dev,proc,sys,run}"

if [ ! -e $BUILDROOT/dev/console ] ; then
	mknod -m 600 $BUILDROOT/dev/console c 5 1
	check $? "2.020-base-build-prep.sh mknod -m 600 $BUILDROOT/dev/console c 5 1"
fi

if [ ! -e $BUILDROOT/dev/null ] ; then
	mknod -m 666 $BUILDROOT/dev/null c 1 3
	check $? "2.020-base-build-prep.sh mknod -m 666 $BUILDROOT/dev/null c 1 3"
fi

if [ ! -e $BUILDROOT/dev ] ; then
	mount -v --bind /dev $BUILDROOT/dev
	check $? "2.020-base-build-prep.sh mount -v --bind /dev $BUILDROOT/dev"
fi

if [ ! -e $BUILDROOT/dev/pts ] ; then
	mount -vt devpts devpts $BUILDROOT/dev/pts -o gid=5,mode=620
	check $? "2.020-base-build-prep.sh mount -vt devpts devpts $BUILDROOT/dev/pts"
fi

if [ ! -e $BUILDROOT/proc ] ; then
	mount -vt proc proc $BUILDROOT/proc
	check $? "2.020-base-build-prep.sh mount -vt proc proc $BUILDROOT/proc"
fi

if [ ! -e $BUILDROOT/sys ] ; then
	mount -vt sysfs sysfs $BUILDROOT/sys
	check $? "2.020-base-build-prep.sh mount -vt sysfs sysfs $BUILDROOT/sys"
fi

if [ ! -e $BUILDROOT/run ] ; then
	mount -vt tmpfs tmpfs $BUILDROOT/run
	check $? "2.020-base-build-prep.sh mount -vt tmpfs tmpfs $BUILDROOT/run"
fi

if [ -h $BUILDROOT/dev/shm ]; then
  mkdir -pv $BUILDROOT/$(readlink $BUILDROOT/dev/shm)
fi

