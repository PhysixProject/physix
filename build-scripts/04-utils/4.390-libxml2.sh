#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3'
chroot_check $? "libxml2 : configure"

su physix -c 'make'
chroot_check $? "libxml2 : make"

make install
chroot_check $? "libxml2 : make install"

