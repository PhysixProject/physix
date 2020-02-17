#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i '9327 s/mv/cp/' Makefile.in
chroot_check $? "6.31-bison sed -i '9327 s/mv/cp/' Makefile.in"

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.3.2
chroot_check $? "6.31-bison ./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.3.2"

make -j1
chroot_check $? "6.31-bison make"

make install
chroot_check $? "6.31-biso nake install"

