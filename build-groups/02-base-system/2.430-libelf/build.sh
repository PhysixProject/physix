#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1
./configure --prefix=/usr
chroot_check $? "libelf configure"

make -j8
chroot_check $? "libelf make"

make check
chroot_check $? "libelf make check" NOEXIT

make -C libelf install
chroot_check $? "libelf make install"

install -vm644 config/libelf.pc /usr/lib/pkgconfig

