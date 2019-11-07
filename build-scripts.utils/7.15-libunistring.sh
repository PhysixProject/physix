#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-0.9.10 
chroot_check $? "libunistring : configure"

make
chroot_check $? "libunistring : make"

make install
chroot_check $? "libunistring : make install"

rm -rf /sources/$SRCD

