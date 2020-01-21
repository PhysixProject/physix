#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.6.9 \
            --disable-guile \
            --with-default-trust-store-pkcs11="pkcs11:"
chroot_check $? "gnutls : configure"

make
chroot_check $? "gnutls : make"

make install
chroot_check $? "gnutls : make install"

