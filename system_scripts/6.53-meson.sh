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


python3 setup.py build
chroot_check $? "meson python3 setup.py build"


python3 setup.py install --root=dest
chroot_check $? "meson python3 setup.py install "

cp -rv dest/* /

rm -rfv /sources/$SRCD

