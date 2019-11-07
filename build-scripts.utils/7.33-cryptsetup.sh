#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr \
            --with-crypto_backend=openssl 
chroot_check $? "cryptsetup: configure"

make
chroot_check $? "cryptsetup: make"

make install
chroot_check $? "cryptsetup: make install"

rm -rf /sources/$SRCD

