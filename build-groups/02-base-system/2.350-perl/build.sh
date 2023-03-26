#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts

export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des -Dprefix=/usr                 \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib                  \
                  -Dusethreads
chroot_check $? "configure"

make -j$NPROC
chroot_check $? "make"

if [ "$CONF_RUN_ALL_TEST_SUITE" == "y" ] ; then
	make -k test
	chroot_check $? "system build : perl : make test " NOEXIT
	# One test fails due to using the most recent version of gdbm.
fi

make install
chroot_check $? "system build : perl : make install"

unset BUILD_ZLIB BUILD_BZIP2

