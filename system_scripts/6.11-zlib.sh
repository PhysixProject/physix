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

./configure --prefix=/usr
chrrot_check $? "system-build : zlib : configure" 

make
chroot_check $? "system-build : zlib : make" 

make check
chroot_check $? "system-build : zlib : make check" noexit

make install
chroot_check $? "system-build : zlib : make install" 

mv -v /usr/lib/libz.so.* /lib
chroot_check $? "system-build : zlib : mv -v /usr/lib/libz.so.* /lib" 'sys'

ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
chroot_check $? "system-build : zlib : ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so"

rm -rfv /sources/$SRCD

