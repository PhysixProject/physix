#!/bin/bash 
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1           

sed -i 's|usr/bin/env |bin/|' run.sh.in

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.6
chroot_check $? "expat configure"

make -j8
chroot_check $? "expat make"

make check
chroot_check $? "expat make check" NOEXIT

make install 
chroot_check $? "expat make install"

# install documentation
#install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.6

