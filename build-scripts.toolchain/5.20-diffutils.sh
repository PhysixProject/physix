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

./configure --prefix=/tools
check "diffutils configure"

make -j8 
check $? "diffutils make"

make check
check $? "diffutils make check" noexit

make install
check $? "diffutils make install"

rm -rf $BUILDROOT/sources/$SRCD
check $? "diffutils: rm -rf $BUILDROOT/sources/$SRCD"

