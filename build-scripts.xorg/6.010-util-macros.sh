#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources/
unpack $PKG
mv $SRCD /sources/xc
cd /sources/xc/$SRCD/

./configure $XORG_CONFIG
make install
chroot_check $? "util-macros  : make"

rm -rf /sources/$SRCD

