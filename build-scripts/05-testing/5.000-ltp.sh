#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c 'make autotools'
chroot_check $? "make autotools"

su physix -c './configure --prefix=/usr/local/bin/ltp'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install
chroot_check $? "make install"

