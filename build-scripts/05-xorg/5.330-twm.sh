#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


su physix -c "sed -i -e '/^rcdir =/s,^\(rcdir = \).*,\1/etc/X11/app-defaults,' src/Makefile.in"
chroot_check $? "sed 1"

su physix -c './configure $XORG_CONFIG' 
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make "

make install
chroot_check $? "make install"

