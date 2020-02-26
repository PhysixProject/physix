#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1
./configure --prefix=/usr                    \
            --enable-shared                  \
            --disable-static                 \
            --docdir=/usr/share/doc/lzo-2.10
chroot_check $? "LZO : configure"
make
chroot_check $? "LZO : make"

make
chroot_check $? "time : make"

make install
chroot_check $? "LZO : make install"

