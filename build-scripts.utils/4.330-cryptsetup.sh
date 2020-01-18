#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

./configure --prefix=/usr \
            --with-crypto_backend=openssl
chroot_check $? "cryptsetup: configure"

make
chroot_check $? "cryptsetup: make"

make install
chroot_check $? "cryptsetup: make install"

