#!/bin/bash
source ../include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


su physix -c 'meson --prefix=/usr .. '
chroot_check $? "meson config"

su physix -c 'ninja'
chroot_check $? "ninja build"

ninja install
chroot_check $? "ninja install"

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


