#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i '/install.*libaio.a/s/^/#/' src/Makefile

make
chroot_check $? "libaio : make"

make install
chroot_check $? "libaio : make install"

