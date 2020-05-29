#!/bin/bash
source /opt/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.6.9 \
            --disable-guile \
            --with-default-trust-store-pkcs11="pkcs11:"'
chroot_check $? "gnutls : configure"

su physix -c 'make'
chroot_check $? "gnutls : make"

make install
chroot_check $? "gnutls : make install"

