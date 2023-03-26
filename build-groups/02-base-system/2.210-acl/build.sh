#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr     \
            --bindir=/bin     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48

chroot_check $? "system-build : acl : configure"

make -j8
chroot_check $? "system-build : acl : make"

make check
chroot_check $? "system-build : acl : make check" NOEXIT

make install
chroot_check $? "system-build : acl : make install"

mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

