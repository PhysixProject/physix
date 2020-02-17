#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

expect -c "spawn ls"
chroot_check $? "system-build : binutils  :expect -c spawn ls"

sed -i '/@\tincremental_copy/d' gold/testsuite/Makefile.in
chroot_check $? "system-build : binutils : sed rm incrementatl_copy"

mkdir -v build
cd       build

../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib

chroot_check $? "system-build : binutils : configure"

make tooldir=/usr
chroot_check $? "system-build : binutils : make"

# CRITICAL, Do not skip
make -k check
chroot_check $? "system-build : binutils : make check"

make tooldir=/usr install
chroot_check $? "system-build : binutils : make install"

