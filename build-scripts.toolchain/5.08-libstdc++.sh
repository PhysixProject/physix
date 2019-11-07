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
                         
unpack $PKG NCHRT
cd $BUILDROOT/sources/$SRCD

mkdir -v build
cd       build

../libstdc++-v3/configure           \
    --host=$BUILDROOT_TGT           \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$BUILDROOT_TGT/include/c++/9.2.0

check $? "stdc++: configure"

make -j8
check $? "stdc++: make"

make install
check $? "stdc++: make install"

rm -rf $BUILDROOT/sources/$SRCD

