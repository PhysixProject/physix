#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1


./configure --disable-documentation
chroot_check $? "dracut config"

make
chroot_check $? "dracut make"

make install
chroot_check $? "dracut make install"

