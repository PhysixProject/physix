#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/xc/$1 || exit 1

sed -i "s/pthread-stubs//" configure &&

./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.13.1 &&
make
chroot_check $? "libxcb :config / make"

make install
chroot_check $? "libxcb : make install"

