#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr 
chroot_check $? "time : configure"

make
chroot_check $? "time : make"

make install
chroot_check $? "time : make install"

rm -rf /sources/$SRCD

