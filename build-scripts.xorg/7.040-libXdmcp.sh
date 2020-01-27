#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/xc/$1 || exit 1

./configure $XORG_CONFIG &&
make
chroot_check $? "libXdmcp: configure and make"

make install
chroot_check $? "libXdmcp : make install"

