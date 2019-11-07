#!/bin/bash 
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh                
cd /sources                                 
PKG=$1              
stripit $PKG        
SRCD=$STRIPPED      
                    
cd /sources         
unpack $PKG
cd /sources/$SRCD   

./configure --prefix=/usr
chroot_check $? "libtool ./configure"

make -j8
chroot_check $? "libtool make"

make -j8 check
# 5 Tests expected to fail
chroot_check $? "libtool make check" noexit

make install
chroot_check $? "libtool make install"

rm -rfv /sources/$SRCD

