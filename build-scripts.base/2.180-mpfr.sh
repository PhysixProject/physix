#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1


./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.0.2
chroot_check $? "system-build : mpfr : configure"

make -j8
chroot_check $? "system-build : mpfr : make "

make html
chroot_check $? "system-build : mpfr : make html"

#critical
make check 
chroot_check $? "system-build : mpfr : make check"                                  

make install
chroot_check $? "system-build : mpfr : make install"

make install-html
chroot_check $? "system-build : mpfr : make install html"

