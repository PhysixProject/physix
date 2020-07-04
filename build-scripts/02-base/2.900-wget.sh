#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr \
  --sysconfdir=/etc         \
  --with-ssl=openssl
chroot_check $? "wget configure"

make
chroot_check $? "wget make"

make install
chroot_check $? "wget make install"

