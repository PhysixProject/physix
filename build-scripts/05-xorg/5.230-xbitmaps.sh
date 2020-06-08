#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


su physix -c './configure $XORG_CONFIG'
chroot_check $? "./configure $XORG_CONFIG"

make install
chroot_check $? "make install"

