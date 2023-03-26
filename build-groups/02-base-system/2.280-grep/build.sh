#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr --bindir=/bin
chroot_check $? "grep ./configure --prefix=/usr --bindir=/bin"

make -j$NPROC
chroot_check $? "grep make"

make -k check
chroot_check $? "grep make -k check" NOEXIT

make install
chroot_check $? "grep make install"

