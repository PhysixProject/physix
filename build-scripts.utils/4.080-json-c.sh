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
chroot_check $? "json-c : configure" 

make
chroot_check $? "json-c : make"

make install
chroot_check $? "json-c : make install"

rm -rf /sources/$SRCD

