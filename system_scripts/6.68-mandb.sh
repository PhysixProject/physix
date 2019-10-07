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

./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.8.5 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap            \
            --with-systemdtmpfilesdir=           \
            --with-systemdsystemunitdir=
chroot_check $? "mandb configure"


make
chroot_check $? "mandb make"

make check
chroot_check $? "mandb make check" noexit

make install
chroot_check $? "mandb make install"

rm -rfv /sources/$SRCD

