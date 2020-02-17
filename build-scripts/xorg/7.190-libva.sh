#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

# NOTE
#This provide VA-API support for some gallium drivers, note that there 
#is a circular dependency. You must build libva first without EGL and GLX 
#support, install this package, and rebuild libva.

./configure $XORG_CONFIG
chroot_check $? "/configure $XORG_CONFIG"

make
chroot_check $? "make"

make install
chroot_check $? "make install"

