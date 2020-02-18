#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

[ ! -e ./build ] || rm -r ./build
su physix -c 'mkdir build'
chroot_check $? "mkdir build"
cd build

su physix -c 'meson --prefix=/usr -Dbuildtype=release ..'
chroot_check $? "config"

su physix -c 'ninja'
chroot_check $? "make"

ninja install
chroot_check $? "make install"

