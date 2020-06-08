#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i "/math.h/a #include <malloc.h>" src/flexdef.h

HELP2MAN=/tools/bin/true \
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4
chroot_check $? "flex  ./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4"
chroot_check $? "configure"

make -j8
chroot_check $? "flex make"

make check
chroot_check $? "flex make check" NOEXIT

make install
chroot_check $? "flex make install"

ln -sv flex /usr/bin/lex
chroot_check $? "sym link flex /usr/bin/lex"

