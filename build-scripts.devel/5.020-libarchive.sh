#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr --disable-static 
chroot_check $? "libarchive : configure"

make
chroot_check $? "libarchive : make"

make install
chroot_check $? "libarchive : make install"

rm -rf /sources/$SRCD

