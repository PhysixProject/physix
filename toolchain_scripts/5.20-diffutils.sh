#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
                                                                                
source /mnt/lfs/physix/include.sh                                                               
source ~/.bashrc

cd /mnt/lfs/sources      
PKG=$1                   
stripit $PKG             
SRCD=$STRIPPED           
                         
unpack $PKG              
cd /mnt/lfs/sources/$SRCD

./configure --prefix=/tools
check "diffutils configure"

make -j8 
check $? "diffutils make"

make check
check $? "diffutils make check" noexit

make install
check $? "diffutils make install"

rm -rf /mnt/lfs/sources/$SRCD
check $? "diffutils: rm -rf /mnt/lfs/sources/$SRCD"

