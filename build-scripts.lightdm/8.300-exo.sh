#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr --sysconfdir=/etc '
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"

