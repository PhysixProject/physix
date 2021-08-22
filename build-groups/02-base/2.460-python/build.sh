#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes
chroot_check $? "python configure"

make -j8
chroot_check $? "python  make"

make install
chroot_check $? "python make install"

chmod -v 755 /usr/lib/libpython3.7m.so
chmod -v 755 /usr/lib/libpython3.so

install -v -dm755 /usr/share/doc/python-3.7.2/html

mkdir -p /usr/share/doc/python-3.7.4/html &&
cp -r ../$2 /usr/share/doc/python-3.7.4/html
chroot_check $? "Install preformatted docs"

ln -s /usr/bin/python3 /usr/bin/python
chroot_check $? "Set python symlink"


