#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr
chroot_check $? "check configure"

make
chroot_check $? "check make"

make check
chroot_check $? "check make check" NOEXIT

make install
chroot_check $? "check make install"

sed -i '1 s/tools/usr/' /usr/bin/checkmk

