#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1           

./configure --prefix=/usr --bindir=/bin
chroot_check $? "grep ./configure --prefix=/usr --bindir=/bin"

make -j8
chroot_check $? "grep eake"

make -k check
chroot_check $? "grep make -k check" noexit

make install
chroot_check $? "grep make install"



