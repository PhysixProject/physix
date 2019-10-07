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


./configure --prefix=/tools --without-bash-malloc
check $? "bash Configre"

make -j8
check $? "bash make"

make tests
check $? "bash make tests" noexit

make install
check $? "bash  make install"

ln -sv bash /tools/bin/sh
check $? "bash: ln -sv bash /tools/bin/sh"

rm -rf /mnt/lfs/sources/$SRCD
check $? "bash: rm -rf /mnt/lfs/sources/$SRCD"

