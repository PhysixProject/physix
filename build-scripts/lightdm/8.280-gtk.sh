#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'mkdir ./build'
cd ./build

su physix -c "meson --prefix=/usr     \
             -Dcolord=yes      \
             -Dgtk_doc=false   \
             -Dman=true        \
             -Dbroadway_backend=true .."
chroot_check $? "configure"

su physix -c "sed -i 's/'--nonet'//' build.ninja"
chroot_check $? "Remove --nonet"

su physix -c 'ninja'
chroot_check $? "ninja"

ninja install
chroot_check $? "ninja install"

#su physix -c 'mkdir -vp ~/.config/'
#cp -rv /physix/build-scripts/lightdm/configs/gtk-3.0/settings.ini 

