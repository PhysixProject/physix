#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1           

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
chroot_check $? "gperf configure"

make
chroot_check $? "gperf make"

#test known to fail if compiled in parallel
make -j1 check
chroot_check $? "gperf make check" NOEXIT

make install
chroot_check $? "gperf make install"

