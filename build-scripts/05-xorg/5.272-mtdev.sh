#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


pwd
./configure --prefix=/usr --disable-static 
chroot_check $? "configure"

make
chroot_check $? "make"

make install
chroot_check $? "make install"

