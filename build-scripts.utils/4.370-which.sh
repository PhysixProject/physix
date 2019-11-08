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
chroot_check $? "which : configure"

make
chroot_check $? "which : make"

make install
chroot_check $? "which : make install"

rm -rf /sources/$SRCD

