#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


chroot_check $? "configure"

chroot_check $? "make -j$NPROC"

chroot_check $? "make install"

