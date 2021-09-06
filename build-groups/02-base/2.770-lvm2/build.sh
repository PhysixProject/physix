#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

SAVEPATH=$PATH                  &&
PATH=$PATH:/sbin:/usr/sbin      &&
./configure --prefix=/usr       \
            --exec-prefix=      \
            --enable-cmdlib     \
            --enable-pkgconfig  \
            --enable-udev_sync
chroot_check $? "lvm2 : configure"

make                            &&
PATH=$SAVEPATH                  &&
unset SAVEPATH
chroot_check $? "lvm2 : make"

make -C tools install_tools_dynamic &&
make -C udev  install                 &&
make -C libdm install
chroot_check $? "lvm2 : make tools/udev/libdm install"

if [ "$CONF_RUN_ALL_TEST_SUITE" == "y" ] ; then
    make check_local
    chroot_check $? "lvm2 : make check local" NOEXIT
fi

make install
chroot_check $? "lvm2 : make install"

