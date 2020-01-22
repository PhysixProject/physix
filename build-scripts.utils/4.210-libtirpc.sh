#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr   \
            --sysconfdir=/etc             \
            --disable-static              \
            --disable-gssapi'
chroot_check $? "libtirpc : configure"

su physix -c 'make'
chroot_check $? "libtirpc : make"

make install &&
mv -v /usr/lib/libtirpc.so.* /lib &&
ln -sfv ../../lib/libtirpc.so.3.0.0 /usr/lib/libtirpc.so
chroot_check $? "libtirpc : make install"

