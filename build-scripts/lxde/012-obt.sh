#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

chroot_check $? "configure"

chroot_check $? "make"

chroot_check $? "make install"

