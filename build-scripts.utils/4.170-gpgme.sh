#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr --disable-gpg-test 
chroot_check $? "gpgme : configure"

make
chroot_check $? "gpgme : make"

make install
chroot_check $? "gpgme : make install"

rm -rf /sources/$SRCD

