#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


su physix -c 'mkdir  libtiff-build'
cd libtiff-build 

su physix -c 'cmake -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libtiff-4.0.10 -DCMAKE_INSTALL_PREFIX=/usr -G Ninja ..'
chroot_check $? 'cmake'

su physix -c 'ninja'
chroot_check $? 'ninja'

ninja install
chroot_check $? 'make install'

