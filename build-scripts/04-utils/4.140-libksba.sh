#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr'
chroot_check $? "libksba : configure "

su physix -c 'make'
chroot_check $? "libksba : make"
make install
chroot_check $? "libksba : make install"

