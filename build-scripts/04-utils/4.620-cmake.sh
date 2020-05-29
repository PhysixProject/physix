#!/bin/bash
source /opt/physix/include.sh || exit 1

sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

su physix -c './bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --docdir=/share/doc/cmake-3.15.2'
chroot_check $? "cmake: bootstrap"

su physix -c 'make'
chroot_check $? "cmake: make"

make install
chroot_check $? "cmake: make install"

