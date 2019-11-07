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
chroot_check $? "popt : configure"

make
chroot_check $? "popt : make"

make install
chroot_check $? "popt : make install"

rm -rf /sources/$SRCD

