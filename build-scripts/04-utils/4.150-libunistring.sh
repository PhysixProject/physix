#!/bin/bash
source /opt/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-0.9.10'
chroot_check $? "libunistring : configure"

su physix -c 'make'
chroot_check $? "libunistring : make"

make install
chroot_check $? "libunistring : make install"

