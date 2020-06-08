#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

PAGE=letter
./configure --prefix=/usr
chroot_check $? "groff configure"

make -j1
chroot_check $? "groff make"

make install
chroot_check $? "groff make install"

