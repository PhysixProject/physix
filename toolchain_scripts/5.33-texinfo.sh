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

./configure --prefix=/tools
check $? "Texinfo: Configure"

make -j8 
check $? "texingo: make"

make check
# Not necessary
check $? "texinfo: make check" noexit

make install
check $? "Texinfo: make install"

rm -rfv $BUILDROOT/sources/$SRCD

