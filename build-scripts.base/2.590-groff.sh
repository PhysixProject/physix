#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1

PAGE=letter
./configure --prefix=/usr
chroot_check $? "groff configure"

make -j1
chroot_check $? "groff make"

make install
chroot_check $? "groff make install"

