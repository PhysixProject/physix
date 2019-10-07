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
check $? "bison Configre"

make 
check $? "bison make"

make check
check $? "bison make chck"

make install
check $? "bison  make install"

rm -rf /mnt/lfs/sources/$SRCD
check $? "bison: rm -rf /mnt/lfs/sources/$SRCD"

