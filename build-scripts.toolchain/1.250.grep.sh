#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source ../../physix/include.sh || exit 1
cd $BUILDROOT/sources/$1 || exit 1
source ~/.bashrc

./configure --prefix=/tools
check $? "Grep: Configure"

make -j8
check $? "Grep make"

make check
check $? "Grep make check" NOEXIT

make install
check $? "grep make install"

