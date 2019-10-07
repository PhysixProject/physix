#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /mnt/lfs/physix/include.sh
LFS='/mnt/lfs'

mkdir -pv $LFS/{dev,proc,sys,run}
check $? "6.02-prep mkdir -pv $LFS/{dev,proc,sys,run}"

mknod -m 600 $LFS/dev/console c 5 1
check $? "6.02-prep mknod -m 600 $LFS/dev/console c 5 1"

mknod -m 666 $LFS/dev/null c 1 3
check $? "6.02-prep mknod -m 666 $LFS/dev/null c 1 3"

mount -v --bind /dev $LFS/dev
check $? "6.02-prep mount -v --bind /dev $LFS/dev"

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
check $? "6.02-prep mount -vt devpts devpts $LFS/dev/pts"

mount -vt proc proc $LFS/proc
check $? "6.02-prep mount -vt proc proc $LFS/proc"

mount -vt sysfs sysfs $LFS/sys
check $? "6.02-prep mount -vt sysfs sysfs $LFS/sys"

mount -vt tmpfs tmpfs $LFS/run
check $? "6.02-prep mount -vt tmpfs tmpfs $LFS/run"

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

