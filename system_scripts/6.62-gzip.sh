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

./configure --prefix=/usr
chroot_check $? "gzip config"

make
chroot_check $? "gzip make"

make check
# Test fail so don't tank it.. (Cross fingers, pray to Satan).
chroot_check $? "gzip make check" noexit

make install
chroot_check $? "gzip make install"

mv -v /usr/bin/gzip /bin

rm -rfv /sources/$SRCD

rm -rfv /sources/$SRCD

