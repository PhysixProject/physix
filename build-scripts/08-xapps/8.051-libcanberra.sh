#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1


su physix -c './configure --prefix=/usr --disable-oss'
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make docdir=/usr/share/doc/libcanberra-0.30 install
chroot_check $? "make install"

