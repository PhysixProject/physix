#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr
chroot_check $? "time : configure"

make
chroot_check $? "time : make"

make install
chroot_check $? "time : make install"

