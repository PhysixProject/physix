#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'make PREFIX=/usr  \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes'
chroot_check $? "pciutils : make"

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes                 \
     install install-lib        &&
chmod -v 755 /usr/lib/libpci.so
chroot_check $? "pciutils : make install"

