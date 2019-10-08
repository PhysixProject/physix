#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../include.sh
source ~/.bashrc

cd $BUILDROOT/sources      
PKG=$1                   
stripit $PKG             
SRCD=$STRIPPED           
                         
unpack $PKG              
cd $BUILDROOT/sources/$SRCD

mkdir -v build
cd       build

../configure                             \
      --prefix=/tools                    \
      --host=$BUILDROOT_TGT                    \
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
$BUILDROOT_TGT-gcc dummy.c
check $? "glibc: $BUILDROOT_TGT-gcc dummy.c"

readelf -l a.out | grep ': /tools'
check $? "Glibc: glibc: $BUILDROOT_TGT-gcc dummy.c"

rm -v dummy.c a.out

rm -rf $BUILDROOT/sources/$SRCD

