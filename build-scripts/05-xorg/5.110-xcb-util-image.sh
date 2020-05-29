#!/bin/bash
source /opt/physix/include.sh
source /etc/profile.d/xorg.sh || exit 2


./configure $XORG_CONFIG
chroot_check $? "xcb-util-image : config"
make
chroot_check $? "xcb-util-image : make "
make install
chroot_check $? "xcb-util-image : make install"

