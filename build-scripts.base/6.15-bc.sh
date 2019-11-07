#!/tools/bin/bash
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

PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3
chroot_check $? "system-build : BC : BC configure" 

make
chroot_check $? "system-build : bc : make" 

make test
chroot_check $? "system-build : bc : make test" noexit

make install
chroot_check $? "system-build : bc : make install" 

rm -rfv /sources/$SRCD

