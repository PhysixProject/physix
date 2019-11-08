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

mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX -Dudev=true &&
ninja
chroot_check $? "libdrm : ninja "

ninja install
chroot_check $? "libdrm : ninja install"

rm -rf /sources/$SRCD

