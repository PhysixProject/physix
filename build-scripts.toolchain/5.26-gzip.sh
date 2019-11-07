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
check $? "gzip: Configure"

make 
check $? "gzip make"

make check
check $? "gzip make check" noexit

make install
check $? "gzip make install"

rm -rfv $BUILDROOT/sources/$SRCD

