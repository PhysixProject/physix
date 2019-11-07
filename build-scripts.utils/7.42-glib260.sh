#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

patch -Np1 -i ../glib-2.60.6-skip_warnings-1.patch

mkdir build &&
cd    build &&

meson --prefix=/usr      \
      -Dman=false         \
      -Dselinux=disabled \
      ..                 &&
ninja
chroot_check $? "glib-2.60 : build"

ninja install &&
mkdir -p /usr/share/doc/glib-2.60.6 &&
cp -r ../docs/reference/{NEWS,gio,glib,gobject} /usr/share/doc/glib-2.60.6
chroot_check $? "glibc 2.60 : make install"

rm -rf /sources/$SRCD

