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
            --docdir=/usr/share/doc/gnutls-3.6.9 \
            --disable-guile \
            --with-default-trust-store-pkcs11="pkcs11:"
chroot_check $? "gnutls : configure"

make
chroot_check $? "gnutls : make"

make install
chroot_check $? "gnutls : make install"

rm -rf /sources/$SRCD

