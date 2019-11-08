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

./configure --prefix=/tools --enable-install-program=hostname
check $? "coreutils configure"

make -j8
check $? "coreutils make"

make RUN_EXPENSIVE_TESTS=yes check
check $? "coreutils make RUN_EXPENSIVE_TESTS=yes check" noexit

make install
check $? "coreutils make install"

rm -rf $BUILDROOT/sources/$SRCD
check $? "coreutils: rm -rf $BUILDROOT/sources/$SRCD"
 
