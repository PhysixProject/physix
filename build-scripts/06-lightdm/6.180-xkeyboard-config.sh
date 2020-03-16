#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

su physix -c "./configure $XORG_CONFIG --with-xkb-rules-symlink=xorg"
chroot_check $? 'configure'

su physix -c 'make'
chroot_check $? 'make'

su physix -c 'make install'
chroot_check $? 'make install' NOEXIT



