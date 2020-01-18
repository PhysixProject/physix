#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

./configure --prefix=/usr --enable-pinentry-tty
chroot_check $? "pinentry: configure"

make
chroot_check $? "pinentry: make"

make install
chroot_check $? "pinentry: make install"

