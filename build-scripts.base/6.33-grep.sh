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

./configure --prefix=/usr --bindir=/bin
chroot_check $? "grep ./configure --prefix=/usr --bindir=/bin"

make -j8
chroot_check $? "grep eake"

make -k check
chroot_check $? "grep make -k check" noexit

make install
chroot_check $? "grep make install"

rm -rfv /sources/$SRCD

