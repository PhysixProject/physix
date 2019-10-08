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


cd unix
./configure --prefix=/tools
check $? "TCL cofigure"

make -j8
check $? "TCL make"

#TZ=UTC make test

make install
check $? "TCL make isntall"

chmod -v u+w /tools/lib/libtcl8.6.so
check $? "TCL chmod -v u+w /tools/lib/libtcl8.6.so"

make install-private-headers
check $? "TCL make install-private-headers"

ln -sv tclsh8.6 /tools/bin/tclsh
check $? "TCL ln -sv tclsh8.6 /tools/bin/tclsh"

rm -rf $BUILDROOT/sources/$SRCD
check $? "TCL: $BUILDROOT/sources/tcl8.6.9"

