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
check $? "tar: Configure"

make -j8 
check $? "Tar: make"

make check
# Not necessary
check $? "Tar: make check" noexit

make install
check $? "Tar: make install"

rm -rfv $BUILDROOT/sources/$SRCD

