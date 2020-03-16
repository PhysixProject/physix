#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr  \
              --disable-static           \
              --with-history             \
              --with-python=/usr/bin/python3'

su physix -c 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"

