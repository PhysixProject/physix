#!/bin/bash
source /opt/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr --enable-pinentry-tty'
chroot_check $? "pinentry: configure"

su physix -c 'make'
chroot_check $? "pinentry: make"

make install
chroot_check $? "pinentry: make install"

