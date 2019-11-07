#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../include.sh
source ~/.bashrc

cd $BUILDROOT/sources      
PKG=$1                   
stripit $PKG NCHRT
SRCD=$STRIPPED           
                         
unpack $PKG NCHRT
cd $BUILDROOT/sources/$SRCD

cp -v configure{,.orig}
check $? "Expect: cp -v configure{,.orig}"

sed 's:/usr/local/bin:/bin:' configure.orig > configure
check $? "Expect: sed 's:/usr/local/bin:/bin:' configure.orig > configure"

./configure --prefix=/tools       \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include
check $? "Expect: Configure"

make -j8
check $? "Expect: make"

make install
check $? "Expect: make install"

make test
check $? "Expect Test" noexit

make SCRIPTS="" install
check $? "Expect: make SCRIPTS="" install"

rm -rf $BUILDROOT/sources/$SRCD
check $? "Expect: $BUILDROOT/sources/expect5.45.4"


