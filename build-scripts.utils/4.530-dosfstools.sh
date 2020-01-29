#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/               \
            --enable-compat-symlinks \
            --mandir=/usr/share/man  \
            --docdir=/usr/share/doc/dosfstools-4.1'
chroot_check $? "dosfstools : configure"

su physix -c 'make'
chroot_check $? "dosfstools : make"

make install
chroot_check $? "parted : make install"

