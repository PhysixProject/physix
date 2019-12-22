#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

./configure --prefix=/usr 
chroot_check $? "haveged : configure"

make
chroot_check $? "haveged : make"

make install &&
mkdir -pv    /usr/share/doc/haveged-1.9.2 &&
cp -v README /usr/share/doc/haveged-1.9.2
chroot_check $? "haveged : make install"

#init script for boot
#make install-haveged

