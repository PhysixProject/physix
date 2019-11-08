#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr --with-gitconfig=/etc/gitconfig 
chroot_check $? "git : configure"

make
chroot_check $? "git : make"

make install
chroot_check $? "git : make install"

rm -rf /sources/$SRCD

