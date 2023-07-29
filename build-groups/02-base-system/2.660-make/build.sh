#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr   \
            --without-guile \
            --build=$(build-aux/config.guess)
chroot_check $? "make configure"

make
chroot_check $? "make"

make DESTDIR=$LFS install
chroot_check $? "make install"


