#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs

sed -i 's/1000/999/' etc/useradd

./configure --sysconfdir=/etc --with-group-name-max-length=32
chroot_check $? "system-build : shadow : configure"

make -j8
chroot_check $? "system-build : shadow : make "

make install
chroot_check $? "system-build : shadow : make install"

mv -v /usr/bin/passwd /bin

