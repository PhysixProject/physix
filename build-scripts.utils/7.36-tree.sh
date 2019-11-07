#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

make
chroot_check $? "tree : make"

make MANDIR=/usr/share/man/man1 install &&
chmod -v 644 /usr/share/man/man1/tree.1
chroot_check $? "tree : make install"

rm -rf /sources/$SRCD

