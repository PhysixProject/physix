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
check $? "dejagnu Configure"

make install
check $? "dejagnu make install"

make check
check $? "dejagnu make check"

rm -rf /mnt/lfs/sources/$SRCD
check $? "dejagnu: mnt/lfs/sources/dejagnu-1.6.2"


