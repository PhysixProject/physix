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

make -j8 PREFIX=/tools install
check $? "bzip2 make PREFIX=/tools install"

rm -rf /mnt/lfs/sources/$SRCD
check $? "bzip2: rm -rf /mnt/lfs/sources/$SRCD"

