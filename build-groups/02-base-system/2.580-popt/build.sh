#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr --disable-static
chroot_check $? "popt : configure"

make
chroot_check $? "popt : make"

make install
chroot_check $? "popt : make install"

