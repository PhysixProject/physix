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

patch -Np1 -i ../kbd-2.0.4-backspace-1.patch

sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in


PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock


make
chroot_check $? "kbd make"

make check
chroot_check $? "kbd make check" noexit

make install
chroot_check $? "kbd make install"

mkdir -v       /usr/share/doc/kbd-2.0.4

cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.4

rm -rfv /sources/$SRCD

