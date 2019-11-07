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

sed -i '/def add_multiarch_paths/a \        return' setup.py

./configure --prefix=/tools --without-ensurepip
check $? "perl: Configure"

make -j8 
check $? "python: make"

make install
check $? "python make install"

rm -rfv $BUILDROOT/sources/$SRCD

