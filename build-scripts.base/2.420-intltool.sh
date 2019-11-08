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

sed -i 's:\\\${:\\\$\\{:' intltool-update.in


./configure --prefix=/usr
chroot_check $? "intltool ./configure --prefix=/usr"

make -j8
chroot_check $? "intltool make"

make check
chroot_check $? "intltool make check" noexit

make install
chroot_check $? "intltool make install"

install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
chroot_check $? "intltool isntall doc"

rm -rfv /sources/$SRCD

