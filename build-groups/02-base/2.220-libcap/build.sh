#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i '/install.*STALIBNAME/d' libcap/Makefile

make -j8
chroot_check $? "system-build : libcap : make"

make RAISE_SETFCAP=no lib=lib prefix=/usr install
chroot_check $? "system-build : libcap : make install"

chmod -v 755 /usr/lib/libcap.so.2.26

mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so

