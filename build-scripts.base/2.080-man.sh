#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh
cd /sources/$1

make install
chroot_check $? "system-build : man pages: make install "

