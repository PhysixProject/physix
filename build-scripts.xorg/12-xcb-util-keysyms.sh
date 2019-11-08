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
chroot_check $? "xcb-util-keysyms : config"
make
chroot_check $? "xcb-util-keysyms : make "
make install
chroot_check $? "xcb-util-keysyms : make install"

rm -rf /sources/$SRCD

