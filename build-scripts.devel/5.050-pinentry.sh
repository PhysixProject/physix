#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr --enable-pinentry-tty 
chroot_check $? "pinentry: configure"

make
chroot_check $? "pinentry: make"

make install
chroot_check $? "pinentry: make install"

rm -rf /sources/$SRCD

