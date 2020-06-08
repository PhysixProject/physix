#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

[ ! -e ./build ] || rm -r ./build
su physix -c 'mkdir build'
cd build

su physix -c 'meson --prefix=/usr -Dgtk_doc=false ..'
chroot_check $? "configure"

su physix -c 'ninja'
chroot_check $? "ninja"

ninja install
chroot_check $? "ninja install"

