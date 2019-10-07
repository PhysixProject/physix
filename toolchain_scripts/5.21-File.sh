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
check $? "File configure"                                                     
                                                                                
make                                                                            
check $? "File make"                                                          

make check                                                                                
check $? "File make check" noexit
                                                                                
make install                                                                    
check $? "File make install"

rm -rf /mnt/lfs/sources/$SRCD
check $? "File: rm -rf /mnt/lfs/sources/$SRCD"

