#!/bin/bash 
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh                
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
chrooted-unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror
chroot_check $? "grub  configure"

make
chroot_check $? "grub make"

make install
chroot_check $? "grub make install"

mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

rm -rfv /sources/$SRCD

