#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/xc/$1 || exit 3

./configure $XORG_CONFIG --disable-devel-docs
chroot_check $? "./configure $XORG_CONFIG --disable-devel-docs"
make 
chroot_check $? "make "
make install
chroot_check $? "make install"

