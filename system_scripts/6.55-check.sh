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
chroot_check $? "check configure"

make
chroot_check $? "check make"

make check
chroot_check $? "check make check" noexit

make install
chroot_check $? "check make install"

sed -i '1 s/tools/usr/' /usr/bin/checkmk

rm -rfv /sources/$SRCD

