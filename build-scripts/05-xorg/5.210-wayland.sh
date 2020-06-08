#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


./configure --prefix=/usr    \
            --disable-static \
            --disable-documentation 
chroot_check $? "Configure"

make
chroot_check $? "make"

make install
chroot_check $? "make install"

