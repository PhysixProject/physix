#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1


./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.1.0
chroot_check $? "system-build : mpc : configure"

make -j8
chroot_check $? "system-build : mpc : make "

make html
chroot_check $? "system-build : mpc : make html"

#critical
make check 
chroot_check $? "system-build : mpc: make check"                                  

make install
chroot_check $? "system-build : mpc : make install"

make install-html
chroot_check $? "system-build : mpc : make install html"



