#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'sed -i '/cmptest/d' tests/CMakeLists.txt'
chroot_check $? "sed"

su physix -c 'mkdir -v build'
cd build 

su physix -c 'cmake -DCMAKE_INSTALL_PREFIX=/usr .. '
chroot_check $? "cmake"

su physix -c 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"

