#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr
chroot_check $? "libgcrypt : configure" 

make
chroot_check $? "libgcrypt : make"

make -C doc html                                                       &&
makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi &&
makeinfo --plaintext       -o doc/gcrypt.txt           doc/gcrypt.texi
chroot_check $? "libgcrypt : make doc"

make install &&
install -v -dm755   /usr/share/doc/libgcrypt-1.8.5 &&
install -v -m644    README doc/{README.apichanges,fips*,libgcrypt*} \
                    /usr/share/doc/libgcrypt-1.8.5 &&

install -v -dm755   /usr/share/doc/libgcrypt-1.8.5/html &&
install -v -m644 doc/gcrypt.html/* \
                    /usr/share/doc/libgcrypt-1.8.5/html &&
install -v -m644 doc/gcrypt_nochunks.html \
                    /usr/share/doc/libgcrypt-1.8.5      &&
install -v -m644 doc/gcrypt.{txt,texi} \
                    /usr/share/doc/libgcrypt-1.8.5
chroot_check $? "libgcrypt : make install"


rm -rf /sources/$SRCD

