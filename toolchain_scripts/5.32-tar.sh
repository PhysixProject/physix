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
check $? "tar: Configure"

make -j8 
check $? "Tar: make"

make check
# Not necessary
check $? "Tar: make check" noexit

make install
check $? "Tar: make install"

rm -rfv /mnt/lfs/sources/$SRCD

