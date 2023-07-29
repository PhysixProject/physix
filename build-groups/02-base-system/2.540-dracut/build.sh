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

install -m644 /opt/admin/physix/build-groups/02-base-system/2.540-dracut/etc_dracut.conf /etc/dracut.conf
chroot_check $? "create /etc/dracut.conf"

