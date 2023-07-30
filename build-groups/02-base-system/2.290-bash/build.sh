#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 

./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.0 \
            --without-bash-malloc            \
            --with-installed-readline
chroot_check $? "bash configure"

make -j8
chroot_check $? "bash make"

chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH HOME=/home make tests"
chroot_check $? "make tests" NOEXIT

make install
chroot_check $? "make install"

mv -vf /usr/bin/bash /bin

