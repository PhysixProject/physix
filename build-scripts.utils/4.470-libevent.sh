#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr --disable-static'
chroot_check $? "libevent : configure"

su physix -c 'make'
chroot_check $? "libevent : make"

make install
chroot_check $? "libevent : make install"

