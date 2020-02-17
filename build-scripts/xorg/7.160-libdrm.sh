#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

if [ -e ./build ] ; then rm -rf ./build; fi
su physix -c "mkdir build"
cd    build 

meson --prefix=$XORG_PREFIX -Dudev=true &&
ninja
chroot_check $? "libdrm : ninja "

ninja install
chroot_check $? "libdrm : ninja install"

