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
check $? "gawk: configure"

make
check $? "gawk: make"

make check
check $? "gawk: make check" noexit

make install
check $? "gawk: make install"

rm -rfv cd /mnt/lfs/sources/$SRCD

