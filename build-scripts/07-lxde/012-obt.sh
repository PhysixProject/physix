#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


chroot_check $? "configure"

chroot_check $? "make -j$NPROC"

chroot_check $? "make install"
[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

