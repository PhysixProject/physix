#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

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

