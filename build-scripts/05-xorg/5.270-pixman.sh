#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


[ ! -e ./build ] || rm -rf ./build

mkdir build &&
cd build 

meson --prefix=/usr &&
ninja
chroot_check $? "meson / ninja"

ninja install
chroot_check $? "ninja install"

