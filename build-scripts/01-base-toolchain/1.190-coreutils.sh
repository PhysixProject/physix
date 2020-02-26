#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/opt/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc


./configure --prefix=/tools --enable-install-program=hostname
check $? "coreutils configure"

make -j8
check $? "coreutils make"

make RUN_EXPENSIVE_TESTS=yes check
check $? "coreutils make RUN_EXPENSIVE_TESTS=yes check" NOEXIT

make install
check $? "coreutils make install"

