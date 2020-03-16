#!/bin/bash
source /opt/physix/include.sh
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

./configure $XORG_CONFIG
chroot_check $? "xcb-util : config"
make
chroot_check $? "xcb-util : make "
make install
chroot_check $? "xcb-util : make install"

