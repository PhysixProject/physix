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

rm -rf /mnt/lfs/sources/$SRCD
check $? "M4: rm -rf /mnt/lfs/sources/m4-1.4.18"

