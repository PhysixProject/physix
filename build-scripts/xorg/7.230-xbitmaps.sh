#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure $XORG_CONFIG'
chroot_check $? "./configure $XORG_CONFIG"

make install
chroot_check $? "make install"

