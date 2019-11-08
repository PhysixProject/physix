#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

patch -Np1 -i ../liboauth-1.0.3-openssl-1.1.0-3.patch
chroot_check $? "liboauth : patch"

./configure --prefix=/usr --disable-static 
chroot_check $? "liboauth : cofnigure"
make
chroot_check $? "liboauth : make"
make install
chroot_check $? "liboauth : make install"

rm -rf /sources/$SRCD

