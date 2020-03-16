#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'mkdir build '
chroot_check $? "create build dir"
cd ./build

su physix -c 'meson --prefix=/usr'
chroot_check $? "configure"

su physix -c 'ninja'
chroot_check $? "ninja"

ninja install
chroot_check $? "ninja install"

