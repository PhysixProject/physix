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
check $? "Sed: Configure"

make -j8
check $? "Sed: make"

make check
# not necessary and often returns non zero
check $? "Sed make check" noexit

make install
check $? "Sed: make install"

rm -rfv /mnt/lfs/sources/$SRCD

