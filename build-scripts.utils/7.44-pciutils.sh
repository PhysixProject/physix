#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes
chroot_check $? "pciutils : make"

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes                 \
     install install-lib        &&
chmod -v 755 /usr/lib/libpci.so
chroot_check $? "pciutils : make install"


rm -rf /sources/$SRCD

