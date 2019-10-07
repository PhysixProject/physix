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

./configure --prefix=/tools --enable-install-program=hostname
check $? "coreutils configure"

make -j8
check $? "coreutils make"

make RUN_EXPENSIVE_TESTS=yes check
check $? "coreutils make RUN_EXPENSIVE_TESTS=yes check" noexit

make install
check $? "coreutils make install"

rm -rf /mnt/lfs/sources/$SRCD
check $? "coreutils: rm -rf /mnt/lfs/sources/$SRCD"
 
