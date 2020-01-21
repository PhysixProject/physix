#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc

mkdir -v build
cd       build

../libstdc++-v3/configure           \
    --host=$BUILDROOT_TGT           \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$BUILDROOT_TGT/include/c++/9.2.0

check $? "stdc++: configure"

make -j8
check $? "stdc++: make"

make install
check $? "stdc++: make install"


