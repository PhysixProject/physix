#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/xc/$1 || exit 1

./configure $XORG_CONFIG
chroot_check $? "xcb-util-cursor : config"
make
chroot_check $? "xcb-util-cursor : make "
make install
chroot_check $? "xcb-util-cursor : make install"

