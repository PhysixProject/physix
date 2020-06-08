#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr --disable-gpg-test'
chroot_check $? "gpgme : configure"

su physix -c 'make'
chroot_check $? "gpgme : make"

make install
chroot_check $? "gpgme : make install"

