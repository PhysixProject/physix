#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in

./configure --prefix=/usr --bindir=/bin
chroot_check $? "system-build : sed : configure"

make -j8
chroot_check $? "system-build : sed : make"

make html
chroot_check $? "system-build : sed : make html"

if [ "$CONF_RUN_ALL_TEST_SUITE"=="y" ] ; then
	make check
	chroot_check $? "system-build : sed : make check" NOEXIT
fi

make install
chroot_check $? "system-build : sed : make install"

install -d -m755           /usr/share/doc/sed-4.7
install -m644 doc/sed.html /usr/share/doc/sed-4.7

