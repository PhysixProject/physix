#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr
chroot_check $? "diffutils configure"

make
chroot_check $? "diffutils make"

make check
chroot_check $? "diffutils make check" NOEXIT

make install
chroot_check $? "diffutils make install"

