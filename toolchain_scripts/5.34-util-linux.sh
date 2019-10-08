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

./configure --prefix=/tools                \
            --without-python               \
            --disable-makeinstall-chown    \
            --without-systemdsystemunitdir \
            --without-ncurses              \
            PKG_CONFIG=""
check $? "util-linux: Configure"

make -j8 
check $? "util-linux: make"

make install
check $? "util-linux make install" 


