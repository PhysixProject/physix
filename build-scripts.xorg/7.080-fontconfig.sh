#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/xc/$1 || exit 1

sed -i "s/pthread-stubs//" configure &&
rm -f src/fcobjshash.h

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.13.1 &&
make
chroot_check $? "fontconfig : make "

make install
chroot_check $? "fontconfig : make install"

