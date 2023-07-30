#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1
sed '361 s/{/\\{/' -i bin/autoscan.in

./configure --prefix=/usr
chroot_check $? "autoconf configure"

make -j8
chroot_check $? "autoconf make"

# if 'make check' runs, it causes chroot_check to not run.
# or so the logs read...
#make check
#chroot_check $? "auto conf make check"

make install
chroot_check $? "autoconf make install"

