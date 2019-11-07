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
chroot_check $? "libtasn : configure"

make
chroot_check $? "libtasn : make"


make install &&
make -C doc/reference install-data-local
chrooted-check $? "make-ca : make install"


rm -rf /sources/$SRCD

