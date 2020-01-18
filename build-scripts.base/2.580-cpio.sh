#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1

./configure --prefix=/usr \
            --bindir=/bin \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt

make
chroot_check $? "cpio make"

make check
chroot_check $? "cpio make check" NOEXIT

make install
chroot_check $? "cpio make install"

