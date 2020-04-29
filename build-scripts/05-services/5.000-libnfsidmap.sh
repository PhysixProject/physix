#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr  \
              --sysconfdir=/etc          \
              --disable-static'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install                         &&
mv -v /usr/lib/libnfsidmap.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libnfsidmap.so) /usr/lib/libnfsidmap.so
chroot_check $? "make install"

