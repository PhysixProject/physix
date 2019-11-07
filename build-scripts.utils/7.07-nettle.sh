#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr --disable-static 
chroot_check $? "nettle : configure" 

make
chroot_check $? "nettle : make"

make install &&
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.5.1 &&
install -v -m644 nettle.html /usr/share/doc/nettle-3.5.1
chroot_check $? "nettle : make install"


rm -rf /sources/$SRCD

