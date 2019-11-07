#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources/xc/
unpack $PKG
cd /sources/$SRCD

sed -i "s/pthread-stubs//" configure &&
rm -f src/fcobjshash.h

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.13.1 &&
make
chroot_check $? "fontconfig : make "

make install
chroot_check $? "fontconfig : make install"

rm -rf /sources/$SRCD

