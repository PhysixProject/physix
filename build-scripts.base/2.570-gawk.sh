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

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr
chroot_check $? "gawk config"

make
chroot_check $? "gawk make"

make check
chroot_check $? "gawk make check" noexit

make install
chroot_check $? "gawk make install"

rm -rfv /sources/$SRCD
