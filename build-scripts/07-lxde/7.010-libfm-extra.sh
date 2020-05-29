#!/bin/bash
source /opt/physix/include.sh || exit 1


su physix -c './configure --prefix=/usr \
            --sysconfdir=/etc \
            --with-extra-only \
            --with-gtk=no     \
            --disable-static'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install
chroot_check $? "make install"

