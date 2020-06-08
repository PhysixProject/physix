#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr'
chroot_check $? "time : configure"

su physix -c 'make'
chroot_check $? "time : make"

make install
chroot_check $? "time : make install"

