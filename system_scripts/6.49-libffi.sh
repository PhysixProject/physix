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


sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in

sed -e '/^includedir/ s/=.*$/=@includedir@/' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in

./configure --prefix=/usr --disable-static --with-gcc-arch=native
chroot_check $? "libffi configure"

make -j8
chroot_check $? "libffi make"

make check 
chroot_check $? "libffi make check" noexit

make install
chroot_check $? "libffi make install"

rm -rfv /sources/$SRCD

