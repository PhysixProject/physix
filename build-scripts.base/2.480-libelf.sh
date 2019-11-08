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
chroot_check $? "libelf configure"

make -j8
chroot_check $? "libelf make"

make check
chroot_check $? "libelf make check" noexit

make -C libelf install
chroot_check $? "libelf make install"

install -vm644 config/libelf.pc /usr/lib/pkgconfig

rm -rfv /sources/$SRCD

