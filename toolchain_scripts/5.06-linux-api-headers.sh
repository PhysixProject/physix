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

make mrproper
check $? "make mrproper"

make INSTALL_HDR_PATH=dest headers_install
check $? "Linux make headers"

cp -rv dest/include/* /tools/include
check $? "cp -rv dest/include/* /tools/include"

rm -rf /mnt/lfs/sources/$SRCD

