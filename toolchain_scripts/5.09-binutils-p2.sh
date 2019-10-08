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

mkdir build
cd build

CC=$BUILDROOT_TGT-gcc          \
AR=$BUILDROOT_TGT-ar           \
RANLIB=$BUILDROOT_TGT-ranlib   \
../configure                   \
    --prefix=/tools            \
    --disable-nls              \
    --disable-werror           \
    --with-lib-path=/tools/lib \
    --with-sysroot


check $? "Binutils pass 2: configure"

make -j8
check $? "Binutils pass 2: make"

make install
check $? "Binutils pass 2: make install"

make -C ld clean
check $? "make -C ld clean"

make -C ld LIB_PATH=/usr/lib:/lib
check $? "make -C ld LIB_PATH=/usr/lib:/lib"

cp -v ld/ld-new /tools/bin
check $? "Binutils pass 2: cp -v ld/ld-new /tools/bin"

rm -rf $BUILDROOT/sources/$SRCD
check $? "rm -rf $BUILDROOT/sources/$SRCD"

