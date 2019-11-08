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

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

./configure --prefix=/tools
check $? "M4 Configure"

make -j8
check $? "M4 make"

make check
check $? "M4 make check" noexit

make install
check $? "M4 make install"

rm -rf $BUILDROOT/sources/$SRCD
check $? "M4: rm -rf $BUILDROOT/sources/m4-1.4.18"

