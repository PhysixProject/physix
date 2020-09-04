#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

patch -Np1 -i ../../coreutils-8.31-i18n-1.patch
chroot_check $? "coreutils patch -Np1 -i ../coreutils-8.30-i18n-1.patch"

sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
chroot_check $? "coreutils suppress test.lock"

autoreconf -fiv
chroot_check $? "coreutils autoreconf"

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --enable-no-install-program=kill,uptime
chroot_check $? "coreutils ./configure"

make
chroot_check $? "coreutils make"

# SKIP TESTS
#make NON_ROOT_USERNAME=nobody check-root
#echo "dummy:x:1000:nobody" >> /etc/group
#chown -Rv nobody .
#su nobody -s /bin/bash \
#          -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
#sed -i '/dummy/d' /etc/group

make install
chroot_check $? "coreutils make install"

mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
mv -v /usr/bin/{head,nice,sleep,touch} /bin
mv -v /usr/bin/mv /bin

