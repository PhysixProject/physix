#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c 'sed 's@-Werror@@' -i Makefile'
chroot_check $? "Sed Makefile"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install
chroot_check $? "make install"

