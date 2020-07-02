#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c 'make build'
chroot_check $? "make build"

make install
chroot_check $? "make install"

