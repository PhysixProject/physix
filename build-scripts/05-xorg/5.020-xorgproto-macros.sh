#!/bin/bash -x
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2



su physix -c 'mkdir ./build'
cd    build

su physix -c "meson --prefix=$XORG_PREFIX .. &&
              ninja"
chroot_check $? "xorgproto : ninja"

ninja install &&
install -vdm 755 $XORG_PREFIX/share/doc/xorgproto-2019.1 &&
install -vm 644 ../[^m]*.txt ../PM_spec $XORG_PREFIX/share/doc/xorgproto-2019.1
chroot_check $? "xorgproto : ninja install"

