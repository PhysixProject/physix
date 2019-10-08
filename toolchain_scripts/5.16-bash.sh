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


./configure --prefix=/tools --without-bash-malloc
check $? "bash Configre"

make -j8
check $? "bash make"

make tests
check $? "bash make tests" noexit

make install
check $? "bash  make install"

ln -sv bash /tools/bin/sh
check $? "bash: ln -sv bash /tools/bin/sh"

rm -rf $BUILDROOT/sources/$SRCD
check $? "bash: rm -rf $BUILDROOT/sources/$SRCD"

