#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

sed -i '/install.*libaio.a/s/^/#/' src/Makefile

make
chroot_check $? "libaio : make"

make install
chroot_check $? "libaio : make install"

