#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr
chroot_check $? "gawk config"

make
chroot_check $? "gawk make"

make check
chroot_check $? "gawk make check" NOEXIT

make install
chroot_check $? "gawk make install"

