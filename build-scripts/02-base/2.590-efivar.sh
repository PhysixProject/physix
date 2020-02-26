#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

patch -Np1 -i ../../efivar-37-gcc_9-1.patch

make libdir=/usr/lib
chroot_check $? "make"

make libdir=/usr/lib install
chroot_check $? "make install"

