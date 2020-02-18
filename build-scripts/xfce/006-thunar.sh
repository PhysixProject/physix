#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1


su physix -c './configure --prefix=/usr \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/Thunar-1.8.9'
chroot_check $? "config"

su physix -c 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"
