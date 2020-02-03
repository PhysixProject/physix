#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/xc/$1 || exit 1

./configure $XORG_CONFIG
chroot_check $? "xcb-util-wm : config"
make
chroot_check $? "xcb-util-wm : make "
make install
chroot_check $? "xcb-util-wm : make install"

