#!/bin/bash 
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1

./configure 
chroot_check $? "configure"

make all
chroot_check $? "make all"

make install
chroot_check $? "make install"

