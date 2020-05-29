#!/bin/bash
source /opt/physix/include.sh || exit 1


su physix -c './configure --prefix=/usr'
chroot_check $? "configure"

make install
chroot_check $? 'make install'

