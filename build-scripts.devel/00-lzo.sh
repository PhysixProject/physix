#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr                    \
            --enable-shared                  \
            --disable-static                 \
            --docdir=/usr/share/doc/lzo-2.10 
chroot_check $? "LZO : configure"
make
chroot_check $? "LZO : make"

make
chroot_check $? "time : make"

make install
chroot_check $? "LZO : make install"

rm -rf /sources/$SRCD

