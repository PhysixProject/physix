#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/xc/$1 || exit 1

./configure $XORG_CONFIG
chroot_check $? "xcp-proto: configure and make"

make install
chroot_check $? "xcb-proto : make install"

