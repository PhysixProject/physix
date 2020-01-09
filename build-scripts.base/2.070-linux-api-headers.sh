#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
export LIBRARY_PATH=/usr/lib/:$LIBRARY_PATH
cd /sources/$1 || exit 1

make mrproper
chroot_check $? "system-build : linux-api-headers: make mrproper "

make INSTALL_HDR_PATH=dest headers_install
chroot_check $? "system-build : make INSTALL_HDR_PATH=dest headers_install"

find dest/include \( -name .install -o -name ..install.cmd \) -delete
chroot_check $? "system-build : find dest/include \( -name .install -o -name ..install.cmd \) -delete"

cp -rv dest/include/* /usr/include
chroot_check $? "system-build : cp -rv dest/include/* /usr/include "

