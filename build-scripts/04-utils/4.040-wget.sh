#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr \
              --sysconfdir=/etc         \
              --with-ssl=openssl'
chroot_check $? "wget configure"

su physix -c 'make'
chroot_check $? "wget make"

make install
chroot_check $? "wget make install"

