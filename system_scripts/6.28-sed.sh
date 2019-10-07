#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh                
cd /sources
PKG=$1              
stripit $PKG        
chroot_check $? "system-build : stripit"
SRCD=$STRIPPED      

cd /sources         
chrooted-unpack $PKG
cd /sources/$SRCD   

sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in

./configure --prefix=/usr --bindir=/bin
chroot_check $? "system-build : sed : configure" 

make -j8
chroot_check $? "system-build : sed : make"

make html
chroot_check $? "system-build : sed : make html"

make check
# Disable check for now. Expected failure because valgrind is not present.
chroot_check $? "system-build : sed : make check" noexit

make install
chroot_check $? "system-build : sed : make install"

install -d -m755           /usr/share/doc/sed-4.7
install -m644 doc/sed.html /usr/share/doc/sed-4.7

rm -rfv /sources/$SRCD

