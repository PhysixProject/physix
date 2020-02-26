#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

make EFIDIR=/mnt/physix/ EFI_LOADER=grubx64.efi
chroot_check $? "make"

install -v -D -m0755 src/efibootmgr /usr/sbin/efibootmgr &&
install -v -D -m0644 src/efibootmgr.8 /usr/share/man/man8/efibootmgr.8
chroot_check $? "install efibootmgr"
