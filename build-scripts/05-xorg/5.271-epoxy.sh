#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


mkdir build &&
cd    build 

meson --prefix=/usr .. &&
ninja
chroot_check $? "mesa / ninja"

ninja install
chroot_check $? "ninja install"

