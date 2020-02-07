#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'mkdir build' 
chroot_check $? "mkdir build"
cd build 

su physix -c 'meson --prefix=/usr .. '
chroot_check $? "meson"

su physix -c "sed -i 's/'--nonet'//' build.ninja"
chroot_check $? "Remove --nonet"

su physix -c 'ninja'
chroot_check $? "ninja"

ninja install
chroot_check $? "ninja install"

