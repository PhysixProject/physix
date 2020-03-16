#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c '. /etc/profile && ./configure --prefix=/usr --enable-vala --disable-static'
chroot_check $? 'configure'

su physix -c '. /etc/profile && make'
chroot_check $? 'make'

make install
chroot_check $? 'make install'

