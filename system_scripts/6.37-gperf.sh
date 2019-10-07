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

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
chroot_check $? "gperf configure"

make
chroot_check $? "gperf make"

#test known to fail if compiled in parallel
make -j1 check
chroot_check $? "gperf make check" noexit

make install
chroot_check $? "gperf make install"

rm -rfv /sources/$SRCD

