#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr --disable-static \
            --with-securedir=/lib/security \
            --with-python-binary=python3'
chroot_check $? "libpwquality : configure"

su physix -c 'make'
chroot_check $? "libpwquality : make"

make install
chroot_check $? "libpwquality : make install"

