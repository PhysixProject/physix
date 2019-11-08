#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

make mrproper
chroot_check $? "system config: kernel : make mr_proper"

make defconfig
chroot_check $? "system config: kernel : make defconfig "

make
chroot_check $? "system config: kernel : make"

make modules_install
chroot_check $? "system config: kernel : make module_install"

cp -iv arch/x86/boot/bzImage /boot/vmlinuz-5.2.8-physix

cp -iv System.map /boot/System.map-5.2.8

cp -iv .config /boot/config-5.2.8

install -d /usr/share/doc/linux-5.2.8
chroot_check $? "system config: kernel : install kernel doc"

cp -r Documentation/* /usr/share/doc/linux-5.2.8


install -v -m755 -d /etc/modprobe.d
chroot_check $? "system config: kernel : install -v -m755 -d /etc/modprobe.d"

cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
chroot_check $? "system config: kernel : /etc/modprobe.d/usb.conf"




