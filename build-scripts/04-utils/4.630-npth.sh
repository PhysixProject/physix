#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr'
chroot_check $? "npth: make install"

su physix -c 'make'
chroot_check $? "npth: make"

make install
chroot_check $? "npth: make install"

