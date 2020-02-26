#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1
./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror       \
            --enable-device-mapper
chroot_check $? "grub configure"

make
chroot_check $? "grub make"

make install
chroot_check $? "grub make install"

mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

