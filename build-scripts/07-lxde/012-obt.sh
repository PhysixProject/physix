#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

chroot_check $? "configure"

chroot_check $? "make -j$NPROC"

chroot_check $? "make install"

