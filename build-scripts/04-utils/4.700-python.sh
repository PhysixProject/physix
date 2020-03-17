#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c "./configure --prefix=/usr       \
              --enable-shared     \
              --with-system-expat \
              --with-system-ffi   \
              --with-ensurepip=yes \
              --enable-unicode=ucs4"
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install &&
chmod -v 755 /usr/lib/libpython2.7.so.1.0
chroot_check $? "make install"

