#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

sed -i '/install.*libaio.a/s/^/#/' src/Makefile

make
chroot_check $? "libaio : make"

make install
chroot_check $? "libaio : make install"

rm -rf /sources/$SRCD

