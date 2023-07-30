#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1
mkdir -pv /var/lib/hwclock

rm -vf /usr/include/{blkid,libmount,uuid}

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --docdir=/usr/share/doc/util-linux-2.33.1 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            --without-systemd    \
            --without-systemdsystemunitdir
chroot_check $? "util-linux configure"

make
chroot_check $? "util-linux make"

# can be run after rebooting
#bash tests/run.sh --srcdir=$PWD --builddir=$PWD

#chown -Rv nobody .
#su nobody -s /bin/bash -c "PATH=$PATH make -k check"

make install
chroot_check $? "util-linux make install"



