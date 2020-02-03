#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/xc/$1 || exit 1

./configure --prefix=/usr    \
            --disable-static \
            --disable-documentation 
chroot_check $? "Configure"

make
chroot_check $? "make"

make install
chroot_check $? "make install"

