#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'mkdir ./build'
chroot_check $? "create build dir"
cd ./build

su physix -c 'meson --prefix=/usr ..'   
chroot_check $? "meson config"

su physix -c 'ninja'
chroot_check $? "ninja build"

ninja install
chroot_check $? "ninja install"

