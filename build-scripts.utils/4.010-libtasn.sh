#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr --disable-static 
chroot_check $? "libtasn : configure"

make
chroot_check $? "libtasn : make"


make install &&
make -C doc/reference install-data-local
chroot_check $? "make-ca : make install"

