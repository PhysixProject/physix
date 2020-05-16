#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

make mrproper
chroot_check $? "system config: kernel : make mr_proper"

install --verbose --mode 644 --owner root --group root /opt/physix/build-scripts/03-base-config/configs/linux_config-5.2.8  /opt/sources.physix/BUILDBOX/$1/.config
chroot_check $? "Set Physix 5.2.8 Linux kernel config"

make -j$NPROC
chroot_check $? "system config: kernel : make"

make modules_install
chroot_check $? "system config: kernel : make module_install"

install --verbose --mode 644 --owner root --group root arch/x86/boot/bzImage  /boot/vmlinuz-5.2.8.physix.x86_64
chroot_check $? "/boot/vmlinuz-5.2.8.physix.x86_64"

install --verbose --mode 644 --owner root --group root System.map  /boot/System.map-5.2.8
chroot_check $? "/boot/System.map-5.2.8"

install --verbose --mode 644 --owner root --group root .config  /boot/config-5.2.8.physix.x86_64
chroot_check $? "/boot/config-5.2.8.physix.x86_64"

install -d /usr/share/doc/linux-5.2.8
chroot_check $? "system config: kernel : install kernel doc"

cp -rp Documentation/*  /usr/share/doc/linux-5.2.8
chroot_check $? "install Documentation/* /usr/share/doc/linux-5.2.8"

install --verbose --mode 755 --directory /etc/modprobe.d
chroot_check $? "Create /etc/modprobe.d"

install --verbose --mode 644 --owner root --group root /opt/physix/build-scripts/03-base-config/configs/usb.conf  /etc/modprobe.d/usb.conf
chroot_check $? "Install /etc/modprobe.d/usb.conf"

mkinitrd --force /boot/initrd-5.2.8.physix.x86_64 5.2.8
chroot_check $? "Install mkinitrd"

install --verbose --mode 644 --owner root --group root /opt/physix/scripts/kinstall  /usr/local/bin
chroot_check $? "Install kinstall"

