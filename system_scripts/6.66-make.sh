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

sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c

./configure --prefix=/usr
chroot_check $? "make configure"

make
chroot_check $? "make make "

make PERL5LIB=$PWD/tests/ check
chroot_check $? "Mkae make check"

make install
chroot_check $? "make make install"

rm -rfv /sources/$SRCD

