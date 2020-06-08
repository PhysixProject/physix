#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr \
              --with-crypto_backend=openssl'
chroot_check $? "cryptsetup: configure"

su physix -c 'make'
chroot_check $? "cryptsetup: make"

make install
chroot_check $? "cryptsetup: make install"

