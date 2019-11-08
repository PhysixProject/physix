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
chroot_check $? "patch configure"

make
chroot_check $? "patch make "

make check
chroot_check $? "patch make check" noexit

make install
chroot_check $? "patch make install "

rm -rfv /sources/$SRCD

