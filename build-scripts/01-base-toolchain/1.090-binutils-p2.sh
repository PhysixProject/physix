#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/opt/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc

mkdir build
cd build

CC=$BUILDROOT_TGT-gcc          \
AR=$BUILDROOT_TGT-ar           \
RANLIB=$BUILDROOT_TGT-ranlib   \
../configure                   \
    --prefix=/tools            \
    --disable-nls              \
    --disable-werror           \
    --with-lib-path=/tools/lib \
    --with-sysroot


check $? "Binutils pass 2: configure"

make -j8
check $? "Binutils pass 2: make"

make install
check $? "Binutils pass 2: make install"

make -C ld clean
check $? "make -C ld clean"

make -C ld LIB_PATH=/usr/lib:/lib
check $? "make -C ld LIB_PATH=/usr/lib:/lib"

cp -v ld/ld-new /tools/bin
check $? "Binutils pass 2: cp -v ld/ld-new /tools/bin"


