#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

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

