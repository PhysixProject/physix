#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 3

sed -i -e "/D_XOPEN/s/5/6/" configure
chroot_check $? "sed configure"

./configure $XORG_CONFIG
chroot_check $? "./configure $XORG_CONFIG"
make 
chroot_check $? "make "
make install
chroot_check $? "make install"

