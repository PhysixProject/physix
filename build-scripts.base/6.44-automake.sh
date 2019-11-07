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

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1
chroot_check $? "automake configure"

make -j8
chroot_check $? "automake make"

make -j4 check
chroot_check $? "automake make check" noexit

make install
chroot_check $? "automake make install"

rm -rfv /sources/$SRCD

