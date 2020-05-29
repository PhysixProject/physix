#!/bin/bash
source /opt/physix/include.sh || exit 1


su physix -c './configure --prefix=/usr \
            --disable-static \
            --program-suffix=-1'
chroot_check $? "configure"

su physix -c 'make GETTEXT_PACKAGE=libwnck-1'
chroot_check $? "make"

make GETTEXT_PACKAGE=libwnck-1 install
chroot_check $? "make install"


