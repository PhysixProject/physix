#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr'
chroot_check $? "which : configure"

su physix -c 'make'
chroot_check $? "which : make"

make install
chroot_check $? "which : make install"

