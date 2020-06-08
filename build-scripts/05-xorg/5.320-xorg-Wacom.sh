#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2



./configure $XORG_CONFIG \
            --with-udev-rules-dir=/lib/udev/rules.d \
            --with-systemd-unit-dir=/lib/systemd/system
chroot_check $? "configure"

make
chroot_check $? "make"

make install
chroot_check $? "make install"

