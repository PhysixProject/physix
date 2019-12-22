#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --docdir=/share/doc/cmake-3.15.2 
chroot_check $? "cmake: bootstrap"

make
chroot_check $? "cmake: make"

make install
chroot_check $? "cmake: make install"

rm -rf /sources/$SRCD

