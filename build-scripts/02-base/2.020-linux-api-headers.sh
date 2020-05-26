#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1
export LIBRARY_PATH=/usr/lib/:$LIBRARY_PATH
cd $SOURCE_DIR/$1 || exit 1

make mrproper
chroot_check $? "system-build : linux-api-headers: make mrproper "

make headers
chroot_check $? "system-build : make INSTALL_HDR_PATH=dest headers_install"

find usr/include -name '.*' -delete &&
rm usr/include/Makefile &&
cp -rv usr/include/* /usr/include
chroot_check $? "system-build : cp -rv dest/include/* /usr/include "

