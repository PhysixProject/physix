#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


su physix -c './configure --prefix=/usr --disable-lua'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install
chroot_check $? "make install"

