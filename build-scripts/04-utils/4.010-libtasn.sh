#!/bin/bash
source /opt/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr --disable-static'
chroot_check $? "libtasn : configure"

su physix -c 'make'
chroot_check $? "libtasn : make"

make install &&
make -C doc/reference install-data-local
chroot_check $? "make-ca : make install"

