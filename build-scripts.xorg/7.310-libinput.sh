#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/xc/$1 || exit 3


[ ! -e ./build ] || rm -r ./build
mkdir build &&
cd    build 

meson --prefix=$XORG_PREFIX \
      -Dudev-dir=/lib/udev  \
      -Ddebug-gui=false     \
      -Dtests=false         \
      -Ddocumentation=false \
      -Dlibwacom=false      \
      ..                    &&
ninja
chroot_check$? "meson / ninja"

ninja install
chroot_check $? "ninja install"

