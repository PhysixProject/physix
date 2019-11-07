#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr                                   \
            --sysconfdir=/etc                               \
            --disable-static                                \
            --disable-gssapi                                
chroot_check $? "libtirpc : configure"

make
chroot_check $? "libtirpc : make"

make install &&
mv -v /usr/lib/libtirpc.so.* /lib &&
ln -sfv ../../lib/libtirpc.so.3.0.0 /usr/lib/libtirpc.so
chroot_check $? "libtirpc : make install"

rm -rf /sources/$SRCD

