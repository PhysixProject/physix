#!/bin/bash 
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

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
chroot_check $? "gdbm ./configure"

make -j8
chroot_check $? "gdbm make"

make check
chroot_check $? "gdbm make check" noexit

make install
chroot_check $? "gdbm make installed"

rm -rfv /sources/$SRCD

