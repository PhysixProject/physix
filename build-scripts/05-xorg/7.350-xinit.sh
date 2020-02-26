#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 3

su physix -c './configure $XORG_CONFIG --with-xinitdir=/etc/X11/app-defaults'
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make "

make install &&
ldconfig
chroot_check $? "make install"

