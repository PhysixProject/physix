#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1
source /opt/physix/physix.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1
sed -i 's/abort.*/FALLTHROUGH;/' src/extract.c

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin
chroot_check $? "tar configure"

make -j8
chroot_check $? "tar make"

if [ "$CONF_RUN_ALL_TEST_SUITE"=="y" ] ; then
	make check
	chroot_check $? "tar make check" NOEXIT
fi

make install
chroot_check $? "tar make install"

make -C doc install-html docdir=/usr/share/doc/tar-1.31
chroot_check $? "tar install doc"

