#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
chroot_check $? "openssl configure"

make -j8
chroot_check $? "openssl make"

make test
chroot_check $? "openssl make test" NOEXIT

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
chroot_check $? "openssl make install"

mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.1a
cp -vfr doc/* /usr/share/doc/openssl-1.1.1a

