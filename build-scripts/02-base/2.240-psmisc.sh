#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr
chroot_check $? "system-build : psmisc : configure"

make -j8
chroot_check $? "system-build : psmisc : make"

make install
chroot_check $? "system-build : psmisc : make install"

mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin

