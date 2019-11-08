#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../include.sh

mkdir -pv $BUILDROOT/{dev,proc,sys,run}
check $? "6.02-prep mkdir -pv $BUILDROOT/{dev,proc,sys,run}"

mknod -m 600 $BUILDROOT/dev/console c 5 1
check $? "6.02-prep mknod -m 600 $BUILDROOT/dev/console c 5 1"

mknod -m 666 $BUILDROOT/dev/null c 1 3
check $? "6.02-prep mknod -m 666 $BUILDROOT/dev/null c 1 3"

mount -v --bind /dev $BUILDROOT/dev
check $? "6.02-prep mount -v --bind /dev $BUILDROOT/dev"

mount -vt devpts devpts $BUILDROOT/dev/pts -o gid=5,mode=620
check $? "6.02-prep mount -vt devpts devpts $BUILDROOT/dev/pts"

mount -vt proc proc $BUILDROOT/proc
check $? "6.02-prep mount -vt proc proc $BUILDROOT/proc"

mount -vt sysfs sysfs $BUILDROOT/sys
check $? "6.02-prep mount -vt sysfs sysfs $BUILDROOT/sys"

mount -vt tmpfs tmpfs $BUILDROOT/run
check $? "6.02-prep mount -vt tmpfs tmpfs $BUILDROOT/run"

if [ -h $BUILDROOT/dev/shm ]; then
  mkdir -pv $BUILDROOT/$(readlink $BUILDROOT/dev/shm)
fi

