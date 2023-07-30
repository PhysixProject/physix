#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

make -j8
chroot_check $? "system-build : iana-etc : make"

make install
chroot_check $? "system-build : iana-etc : make install"

