#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


./configure $XORG_CONFIG            \
            --enable-glamor         \
            --enable-suid-wrapper   \
            --with-xkb-output=/var/lib/xkb
chroot_check $? "./configure $XORG_CONFIG"

make 
chroot_check $? "make "

make install &&
mkdir -pv /etc/X11/xorg.conf.d
chroot_check $? "make install"

