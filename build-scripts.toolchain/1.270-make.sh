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

sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c


./configure --prefix=/tools --without-guile
check $? "make: Configure"

make 
check $? "make: make"

make check
check $? "make make check" noexit

make install
check $? "make make install"

rm -rfv $BUILDROOT/sources/$SRCD

