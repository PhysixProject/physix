#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/physix.conf || exit 1

su physix -c './configure --prefix=/usr --disable-static'
chroot_check $? "libSSH2 : configure"

su physix -c 'make'
chroot_check $? "libSSH2 : make "

make install
chroot_check $? "libSSH2 : make install"

