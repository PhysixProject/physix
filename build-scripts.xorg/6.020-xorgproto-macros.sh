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

mkdir build
cd    build
meson --prefix=$XORG_PREFIX .. &&
ninja
chroot_check $? "xorgproto : ninja"


ninja install &&
install -vdm 755 $XORG_PREFIX/share/doc/xorgproto-2019.1 &&
install -vm 644 ../[^m]*.txt ../PM_spec $XORG_PREFIX/share/doc/xorgproto-2019.1
chroot_check $? "xorgproto : ninja install"

