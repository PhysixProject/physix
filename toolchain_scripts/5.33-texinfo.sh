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
check $? "Texinfo: Configure"

make -j8 
check $? "texingo: make"

make check
# Not necessary
check $? "texinfo: make check" noexit

make install
check $? "Texinfo: make install"

rm -rfv /mnt/lfs/sources/$SRCD

