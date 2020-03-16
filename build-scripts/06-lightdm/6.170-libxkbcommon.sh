#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

su physix -c "./configure $XORG_CONFIG --docdir=/usr/share/doc/libxkbcommon-0.8.4" 
chroot_check $? 'configure'

su physix -c 'make'
chroot_check $? 'make'

make install
chroot_check $? 'make install'

