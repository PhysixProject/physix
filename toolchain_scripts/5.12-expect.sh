#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /mnt/lfs/physix/include.sh
source ~/.bashrc

cd /mnt/lfs/sources      
PKG=$1                   
stripit $PKG             
SRCD=$STRIPPED           
                         
unpack $PKG              
cd /mnt/lfs/sources/$SRCD

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

rm -rf /mnt/lfs/sources/$SRCD
check $? "Expect: /mnt/lfs/sources/expect5.45.4"


