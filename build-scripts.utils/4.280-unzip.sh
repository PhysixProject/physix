#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

make -f unix/Makefile generic
chroot_check $? "unzip : make generic"

make prefix=/usr MANDIR=/usr/share/man/man1 \
 -f unix/Makefile install
chroot_check $? "unzip : make install"

rm -rf /sources/$SRCD

