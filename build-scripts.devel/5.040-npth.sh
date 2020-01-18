#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

./configure --prefix=/usr
chroot_check $? "npth: make install"

make
chroot_check $? "npth: make "

make install
chroot_check $? "npth: make install"

