#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source ../../physix/include.sh || exit 1
cd $BUILDROOT/sources/$1 || exit 1
source ~/.bashrc                        

./configure --prefix=/tools
check $? "gawk: configure"

make
check $? "gawk: make"

make check
check $? "gawk: make check" noexit

make install
check $? "gawk: make install"

