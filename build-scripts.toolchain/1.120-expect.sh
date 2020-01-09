#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source ../../physix/include.sh || exit 1
cd $BUILDROOT/sources/$1 || exit 1
source ~/.bashrc                        

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
check $? "Expect Test" NOEXIT

make SCRIPTS="" install
check $? "Expect: make SCRIPTS="" install"

