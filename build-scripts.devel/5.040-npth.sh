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
chroot_check $? "npth: make install"

make
chroot_check $? "npth: make "

make install
chroot_check $? "npth: make install"

rm -rf /sources/$SRCD

