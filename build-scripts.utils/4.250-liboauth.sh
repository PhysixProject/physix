#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

patch -Np1 -i ../liboauth-1.0.3-openssl-1.1.0-3.patch
chroot_check $? "liboauth : patch"

./configure --prefix=/usr --disable-static
chroot_check $? "liboauth : cofnigure"
make
chroot_check $? "liboauth : make"
make install
chroot_check $? "liboauth : make install"

