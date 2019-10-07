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

./configure --prefix=/usr
chroot_check $? "diffutils configure"

make
chroot_check $? "diffutils make"

make check
chroot_check $? "diffutils make check" noexit

make install
chroot_check $? "diffutils make install"

rm -rfv /sources/$SRCD

