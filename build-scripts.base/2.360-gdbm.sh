#!/bin/bash 
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1           

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
chroot_check $? "gdbm ./configure"

make -j8
chroot_check $? "gdbm make"

make check
chroot_check $? "gdbm make check" NOEXIT

make install
chroot_check $? "gdbm make installed"

