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

PAGE=letter
./configure --prefix=/usr
chroot_check $? "groff configure"

make -j1
chroot_check $? "groff make"

make install
chroot_check $? "groff make install"

rm -rfv /sources/$SRCD

