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

sed -i 's/abort.*/FALLTHROUGH;/' src/extract.c

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin
chroot_check $? "tar configure"

make -j8
chroot_check $? "tar make"

make check
chroot_check $? "tar make check" noexit

make install
chroot_check $? "tar make install"

make -C doc install-html docdir=/usr/share/doc/tar-1.31
chroot_check $? "tar install doc"

rm -rfv /sources/$SRCD

