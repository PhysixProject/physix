#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

[ ! -e ./build ] || rm -r ./build

su physix -c 'patch -Np1 -i ../glib-2.60.6-skip_warnings-1.patch'

su physix -c 'mkdir build &&
              cd build &&
              meson --prefix=/usr \
              -Dman=false         \
              -Dselinux=disabled  \
              .. && ninja'
chroot_check $? "glib-2.60 : build"

cd build && 
ninja install &&
mkdir -p /usr/share/doc/glib-2.60.6 &&
cp -r ../docs/reference/{NEWS,gio,glib,gobject} /usr/share/doc/glib-2.60.6
chroot_check $? "glibc 2.60 : make install"

