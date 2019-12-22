#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1           

make -j8 
chroot_check $? "system-build : iana-etc : make"

make install 
chroot_check $? "system-build : iana-etc : make install"



