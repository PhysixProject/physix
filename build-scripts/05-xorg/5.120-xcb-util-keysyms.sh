#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


./configure $XORG_CONFIG
chroot_check $? "xcb-util-keysyms : config"
make
chroot_check $? "xcb-util-keysyms : make "
make install
chroot_check $? "xcb-util-keysyms : make install"

