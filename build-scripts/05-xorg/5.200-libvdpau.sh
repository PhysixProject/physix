#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


[ ! -e ./build ] || rm -r build

mkdir build &&
cd    build &&
meson --prefix=$XORG_PREFIX .. &&
ninja
chroot_check $? "meson / ninja"

ninja install
chroot_check $? "ninja install"

