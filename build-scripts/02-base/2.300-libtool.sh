#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr
chroot_check $? "libtool ./configure"

make -j8
chroot_check $? "libtool make"

make -j8 check
# 5 Tests expected to fail
chroot_check $? "libtool make check" NOEXIT

make install
chroot_check $? "libtool make install"

