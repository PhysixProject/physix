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
check $? "bison Configre"

make 
check $? "bison make"

make check
check $? "bison make chck"

make install
check $? "bison  make install"

rm -rf $BUILDROOT/sources/$SRCD
check $? "bison: rm -rf $BUILDROOT/sources/$SRCD"

