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
check $? "dejagnu Configure"

make install
check $? "dejagnu make install"

make check
check $? "dejagnu make check"

rm -rf $BUILDROOT/sources/$SRCD
check $? "dejagnu: $BUILDROOT/sources/dejagnu-1.6.2"


