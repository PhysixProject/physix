#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr --sysconfdir=/etc
chroot_check $? "less configure"

make
chroot_check $? "less make"

make install
chroot_check $? "less make install"



