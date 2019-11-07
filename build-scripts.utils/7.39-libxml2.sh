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
            --with-history   \
            --with-python=/usr/bin/python3 
chroot_check $? "libxml2 : configure"

make
chroot_check $? "libxml2 : make"

make install
chroot_check $? "libxml2 : make install"

rm -rf /sources/$SRCD

