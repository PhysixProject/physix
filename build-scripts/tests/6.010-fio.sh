#!/bin/bash 
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1           

./configure 
chroot_check $? "configure"

make 
chroot_check $? "make"

make install
chroot_check $? "make install"

