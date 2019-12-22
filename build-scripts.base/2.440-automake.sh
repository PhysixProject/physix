#!/bin/bash 
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1           

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1
chroot_check $? "automake configure"

make -j8
chroot_check $? "automake make"

make -j4 check
chroot_check $? "automake make check" noexit

make install
chroot_check $? "automake make install"

