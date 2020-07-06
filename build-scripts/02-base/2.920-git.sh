#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr --with-gitconfig=/etc/gitconfig --with-curl
chroot_check $? "git : configure"

make -j$NPROC
chroot_check $? "git : make"

make install
chroot_check $? "git : make install"

