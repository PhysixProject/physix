#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1


su physix -c 'sh autogen.sh &&
./configure --prefix=/usr --disable-static'
chroot_check $? "libuv : configure"

su physix -c 'make'
chroot_check $? "libuv : make"

make install
chroot_check $? "libuv : make install"

