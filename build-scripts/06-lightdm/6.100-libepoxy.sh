#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


su physix -c 'meson --prefix=/usr .. '
chroot_check $? "meson config"

su physix -c 'ninja'
chroot_check $? "ninja build"

ninja install
chroot_check $? "ninja install"

