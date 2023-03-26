#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in

sed -e '/AppData/{N;N;p;s/\.appdata\./.metainfo./}' \
    -i gettext-tools/its/appdata.loc

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.19.8.1
chroot_check $? "gettext configure"

make -j8
chroot_check $? "gettext make"

make check
chroot_check $? "gettext make check" NOEXIT

make install
chroot_check $? "gettext make install"

chmod -v 0755 /usr/lib/preloadable_libintl.so

