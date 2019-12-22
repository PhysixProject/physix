#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1    

PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3
chroot_check $? "system-build : BC : BC configure" 

make
chroot_check $? "system-build : bc : make" 

make test
chroot_check $? "system-build : bc : make test" noexit

make install
chroot_check $? "system-build : bc : make install" 

