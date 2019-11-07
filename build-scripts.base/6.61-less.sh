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

./configure --prefix=/usr --sysconfdir=/etc
chroot_check $? "less configure"

make
chroot_check $? "less make"

make install
chroot_check $? "less make install"

rm -rfv /sources/$SRCD

