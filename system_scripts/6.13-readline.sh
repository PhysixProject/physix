#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh                

cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
chrooted-unpack $PKG
cd /sources/$SRCD

sed -i '/MV.*old/d' Makefile.in
chroot_check $? "system-build : readline : sed 1" 

sed -i '/{OLDSUFF}/c:' support/shlib-install
chroot_check $? "system-build : readline : sed 2" 

./configure --prefix=/usr  --disable-static --docdir=/usr/share/doc/readline-8.0
chroot_check $? "system-build : readline : configure" 

make SHLIB_LIBS="-L/tools/lib -lncursesw"
chroot_check $? "system-build : readline : make" 

make SHLIB_LIBS="-L/tools/lib -lncursesw" install
chroot_check $? "system-build : readline : make install" 

mv -v /usr/lib/lib{readline,history}.so.* /lib
chmod -v u+w /lib/lib{readline,history}.so.*
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.0
chroot_check $? "system-build : readline : install"

rm -rfv /sources/$SRCD

