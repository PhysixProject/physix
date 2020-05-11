#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
chroot_check $? "configure"

make
chroot_check $? "make"

make install &&
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
chroot_check $? "make install"

