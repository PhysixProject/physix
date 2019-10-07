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

mkdir -v build
cd       build

../configure                             \
      --prefix=/tools                    \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=/tools/include

check $? "Glibc Configure"

make
check $? "Glibc make"

make install
check $? "Glibc make install"

#sanity check
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
check $? "glibc: $LFS_TGT-gcc dummy.c"

readelf -l a.out | grep ': /tools'
check $? "Glibc: glibc: $LFS_TGT-gcc dummy.c"

rm -v dummy.c a.out

rm -rf /mnt/lfs/sources/$SRCD

