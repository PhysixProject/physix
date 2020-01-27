#!/bin/bash
source /physix/include.sh
cd $SOURCE_DIR/xc/$1 || exit 1

./configure $XORG_CONFIG &&
make
chroot_check $? "libxau  : configure and make"

make install
chroot_check $? "libxau : make install"

