#!/bin/bash
source /physix/include.sh
cd $SOURCE_DIR/xc/$1 || exit 1

./configure $XORG_CONFIG
make install
chroot_check $? "util-macros  : make"

