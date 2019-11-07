#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

sh autogen.sh &&
./configure --prefix=/usr --disable-static 
chroot_check $? "libuv : configure"

make
chroot_check $? "libuv : make"

make install
chroot_check $? "libuv : make install"

rm -rf /sources/$SRCD

