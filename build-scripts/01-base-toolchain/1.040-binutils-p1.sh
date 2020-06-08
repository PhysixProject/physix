#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /mnt/physix/opt/admin/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc

mkdir -v build
cd       build

../configure --prefix=/tools --with-sysroot=$BUILDROOT --with-lib-path=/tools/lib --target=$BUILDROOT_TGT --disable-nls --disable-werror
check $? "Binutils Configure"

make -j8
check $? "Binutils make"


case $(uname -m) in
  x86_64) mkdir -v /tools/lib && ln -sfv lib /tools/lib64 ;;
esac

make install
check $? "Binutils make install"

exit 0

