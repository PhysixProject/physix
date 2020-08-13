#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

if [ $CONF_UEFI_ENABLE == "n" ] ; then
	exit 0
fi

#make EFIDIR=/mnt/physix/ EFI_LOADER=grubx64.efi
make EFIDIR=PHYSIX EFI_LOADER=grubx64.efi
chroot_check $? "make"

install -v -D -m0755 src/efibootmgr /usr/sbin/efibootmgr &&
install -v -D -m0644 src/efibootmgr.8 /usr/share/man/man8/efibootmgr.8
chroot_check $? "install efibootmgr"

