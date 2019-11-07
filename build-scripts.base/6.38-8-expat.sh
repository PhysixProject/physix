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

sed -i 's|usr/bin/env |bin/|' run.sh.in

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.6
chroot_check $? "expat configure"

make -j8
chroot_check $? "expat make"

make check
chroot_check $? "expat make check" noexit

make install 
chroot_check $? "expat make install"

# install documentation
#install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.6

rm -rfv /sources/$SRCD

