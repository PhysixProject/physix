#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/xc/$1 || exit 1

mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX -Dudev=true &&
ninja
chroot_check $? "libdrm : ninja "

ninja install
chroot_check $? "libdrm : ninja install"

