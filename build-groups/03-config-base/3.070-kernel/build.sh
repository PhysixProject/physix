#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

VERSION=$(echo $1 | cut -d- -f2)
DOTCOUNT=`awk -F"." '{print NF-1}' <<< "${VERSION}"`
if [ $DOTCOUNT == 1 ] ; then
	VERSION=$VERSION".0"
fi

make mrproper
chroot_check $? "system config: kernel : make mr_proper"

install --verbose --mode 644 --owner root --group root $PKG_DIR_PATH/linux_kernel.config  /opt/admin/sources.physix/BUILDBOX/$1/.config
chroot_check $? "Set Linux kernel config"

make -j$NPROC
chroot_check $? "system config: kernel : make"

make modules_install
chroot_check $? "system config: kernel : make module_install"

install --verbose --mode 644 --owner root --group root arch/x86/boot/bzImage  /boot/vmlinuz-$VERSION.physix.x86_64
chroot_check $? "/boot/vmlinuz-$VERSION.physix.x86_64"

install --verbose --mode 644 --owner root --group root System.map  /boot/System.map-$VERSION
chroot_check $? "/boot/System.map-$VERSION"

install --verbose --mode 644 --owner root --group root .config  /boot/config-$VERSION.physix.x86_64
chroot_check $? "/boot/config-$VERSION.physix.x86_64"

install -d /usr/share/doc/linux-$VERSION
chroot_check $? "system config: kernel : install kernel doc"

cp -rp Documentation/*  /usr/share/doc/linux-$VERSION
chroot_check $? "install Documentation/* /usr/share/doc/linux-$VERSION"

install --verbose --mode 755 --directory /etc/modprobe.d
chroot_check $? "Create /etc/modprobe.d"

install --verbose --mode 644 --owner root --group root $PKG_DIR_PATH/usb.conf  /etc/modprobe.d/usb.conf
chroot_check $? "Install /etc/modprobe.d/usb.conf"

mkinitrd --force /boot/initrd-$VERSION.physix.x86_64 $VERSION
chroot_check $? "Install mkinitrd"

install --verbose --mode 744 --owner root --group root /opt/admin/physix/scripts/kinstall  /usr/local/bin
chroot_check $? "Install kinstall"

