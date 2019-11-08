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
check $? "gawk: configure"

make
check $? "gawk: make"

make check
check $? "gawk: make check" noexit

make install
check $? "gawk: make install"

rm -rfv cd $BUILDROOT/sources/$SRCD

