#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


su physix -c './configure --prefix=/usr  \
              --disable-static           \
              --with-history             \
              --with-python=/usr/bin/python3'

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install
chroot_check $? "make install"

