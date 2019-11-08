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
chroot_check $? "libgpg-error : configure" 

sed -i 's/namespace/pkg_&/' src/Makefile.{am,in} src/mkstrtable.awk

./configure --prefix=/usr &&
make
chroot_check $? "libgpg-error : make"

make install &&
install -v -m644 -D README /usr/share/doc/libgpg-error-1.36/README
chroot_check $? "libgpg-error : make install"

rm -rf /sources/$SRCD

