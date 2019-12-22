#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1

./configure --prefix=/usr
chroot_check $? "system-build : file : configure" 

make
chroot_check $? "system-build : file : make" 

make check
chroot_check $? "system-build : file : make check" noexit 

make install
chroot_check $? "system-build : file : make install" 



