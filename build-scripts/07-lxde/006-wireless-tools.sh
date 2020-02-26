#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch'
chroot_check $? "patch"

su physix -c 'make'
chroot_check $? "make"

make PREFIX=/usr INSTALL_MAN=/usr/share/man install
chroot_check $? "make install"
