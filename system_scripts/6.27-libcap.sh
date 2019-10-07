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

sed -i '/install.*STALIBNAME/d' libcap/Makefile

make -j8
chroot_check $? "system-build : libcap : make"

make RAISE_SETFCAP=no lib=lib prefix=/usr install
chroot_check $? "system-build : libcap : make install" 

chmod -v 755 /usr/lib/libcap.so.2.26

mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so

rm -rfv /sources/$SRCD

