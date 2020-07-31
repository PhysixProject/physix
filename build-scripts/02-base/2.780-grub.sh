#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf || exit 1

cd $SOURCE_DIR/$1 || exit 1


if [ $CONF_UEFI_ENABLE == "n" ] ; then
	./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror       \
            --enable-device-mapper
	chroot_check $? "UEFI=n, grub configure"
else
	exit 1
fi


make
chroot_check $? "grub make"

make install
chroot_check $? "grub make install"

mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

