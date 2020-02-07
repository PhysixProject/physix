#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'meson --prefix=/usr .. '
chroot_check $? "meson config"

su physix -c 'ninja'
chroot_check $? "ninja build"

ninja install
chroot_check $? "ninja install"

