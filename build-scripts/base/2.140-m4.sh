#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
chroot_check $? "system-build : readline : sed 2" 'sys'

./configure --prefix=/usr
chroot_check $? "system-build : m4 : configure"

make
chroot_check $? "system-build : m4 : make"

make check
chroot_check $? "system-build : m4 : make check" NOEXIT

make install
chroot_check $? "system-build : m4 : make install"

