#!/bin/bash

source /physix/include.sh

cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources/
unpack $PKG
mv $SRCD /sources/xc
cd /sources/xc/$SRCD/

sed -i "s/pthread-stubs//" configure &&

./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.13.1 &&
make
chroot_check $? "libxcb :config / make"

make install
chroot_check $? "libxcb : make install"

