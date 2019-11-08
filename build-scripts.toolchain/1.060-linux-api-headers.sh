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

make mrproper
check $? "make mrproper"

make INSTALL_HDR_PATH=dest headers_install
check $? "Linux make headers"

cp -rv dest/include/* /tools/include
check $? "cp -rv dest/include/* /tools/include"

rm -rf $BUILDROOT/sources/$SRCD

