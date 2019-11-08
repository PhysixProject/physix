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
chroot_check $? "libassuan : configure"

make                      &&
make -C doc html                                                       &&
makeinfo --html --no-split -o doc/assuan_nochunks.html doc/assuan.texi &&
makeinfo --plaintext       -o doc/assuan.txt           doc/assuan.texi
chroot_check $? "libassuan : make"

make install &&
install -v -dm755   /usr/share/doc/libassuan-2.5.3/html &&
install -v -m644 doc/assuan.html/* \
                    /usr/share/doc/libassuan-2.5.3/html &&
install -v -m644 doc/assuan_nochunks.html \
                    /usr/share/doc/libassuan-2.5.3      &&
install -v -m644 doc/assuan.{txt,texi} \
                    /usr/share/doc/libassuan-2.5.3
chroot_check $? "libassuan : make install"

rm -rf /sources/$SRCD

