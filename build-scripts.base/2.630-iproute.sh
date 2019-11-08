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

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

sed -i 's/.m_ipt.o//' tc/Makefile

make
chroot_check $? "iproute make"

make DOCDIR=/usr/share/doc/iproute2-4.20.0 install
chroot_check $? "iproute make install"

rm -rfv /sources/$SRCD

rm -rfv /sources/$SRCD

