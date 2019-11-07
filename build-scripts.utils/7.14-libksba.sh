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
chroot_check $? "libksba : configure "
make
chroot_check $? "libksba : make"
make install
chroot_check $? "libksba : make install"

rm -rf /sources/$SRCD

