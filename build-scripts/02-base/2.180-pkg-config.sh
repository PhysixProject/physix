#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2
chroot_check $? "system-build : pkg config  : config"

make -j8
chroot_check $? "system-build : pkg config  : make"

make check
chroot_check $? "system-build : pkg config : make check" NOEXIT

make install
chroot_check $? "system-build : pkg config : make install"

