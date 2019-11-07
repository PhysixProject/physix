#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

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

rm -rf /sources/$SRCD

