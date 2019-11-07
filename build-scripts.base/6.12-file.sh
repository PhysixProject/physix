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

./configure --prefix=/usr
chroot_check $? "system-build : file : configure" 

make
chroot_check $? "system-build : file : make" 

make check
chroot_check $? "system-build : file : make check" noexit 

make install
chroot_check $? "system-build : file : make install" 

rm -rfv /sources/$SRCD

