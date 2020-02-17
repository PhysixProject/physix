#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr --disable-static'
chroot_check $? "libarchive : configure"

su physix -c 'make'
chroot_check $? "libarchive : make"

make install
chroot_check $? "libarchive : make install"

