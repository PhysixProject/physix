#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --disable-documentation
chroot_check $? "dracut config"

make
chroot_check $? "dracut make"

make install
chroot_check $? "dracut make install"

