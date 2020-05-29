#!/bin/bash
source /opt/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr    \
            --disable-static \
            --with-installbuilddir=/usr/share/apr-1/build' 
chroot_check $? "configure"

touch libtoolT
su physix -c "make -j$NPROC"
chroot_check $? "make"

make install
chroot_check $? "make install"

