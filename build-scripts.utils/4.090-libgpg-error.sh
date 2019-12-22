#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

./configure --prefix=/usr --disable-static 
chroot_check $? "libgpg-error : configure" 

sed -i 's/namespace/pkg_&/' src/Makefile.{am,in} src/mkstrtable.awk

./configure --prefix=/usr &&
make
chroot_check $? "libgpg-error : make"

make install &&
install -v -m644 -D README /usr/share/doc/libgpg-error-1.36/README
chroot_check $? "libgpg-error : make install"

