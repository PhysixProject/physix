#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr --with-gitconfig=/etc/gitconfig'
chroot_check $? "git : configure"

su physix -c 'make'
chroot_check $? "git : make"

make install
chroot_check $? "git : make install"

