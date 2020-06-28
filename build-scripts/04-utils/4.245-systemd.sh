#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/admin/physix/include.sh || exit 1

patch -Np1 -i ../systemd-243-consolidated_fixes-2.patch
chroot_check $? "systemd : patch systemd-243-consolidated_fixes-2.patch"

sed '177,$ d' -i src/resolve/meson.build &&
sed -i 's/GROUP="render", //' rules/50-udev-default.rules.in
chroot_check $? "systemd :"

mkdir -p build
cd       build

PKG_CONFIG_PATH="/usr/lib/pkgconfig" \
LANG=en_US.UTF-8                   \
meson --prefix=/usr                \
      --sysconfdir=/etc            \
      --localstatedir=/var         \
      -Dblkid=true                 \
      -Dbuildtype=release          \
      -Ddefault-dnssec=no          \
      -Dfirstboot=false            \
      -Dinstall-tests=false        \
      -Dkmod-path=/bin/kmod        \
      -Dldconfig=false             \
      -Dmount-path=/bin/mount      \
      -Drootprefix=                \
      -Drootlibdir=/lib            \
      -Dsplit-usr=true             \
      -Dsulogin-path=/sbin/sulogin \
      -Dsysusers=false             \
      -Dumount-path=/bin/umount    \
      -Db_lto=false                \
      -Drpmmacrosdir=no            \
      ..
chroot_check $? "systemd : configure"

LANG=en_US.UTF-8 ninja
chroot_check $? "systemd : ninja"

systemctl daemon-reload
chroot_check $? "Daemon Reload"

sync
sync

LANG=en_US.UTF-8 ninja install
chroot_check $? "systemd : ninja install"

systemctl daemon-reload
chroot_check $? "Daemon Reload"

systemd-machine-id-setup
chroot_check $? "systemd : systemd-machine-id-setup"

systemctl preset-all
chroot_check $? "systemd : systemctl preset-all"

systemctl disable systemd-time-wait-sync.service
chroot_check $? "systemd : disable systemd-time-wait-sync.service"

sed -i 's/#Storage=.*/Storage=persistent/' /etc/systemd/journald.conf
chroot_check $? "journald set to persist logs"

#rm -f /etc/sysctl.d/50-pid-max.conf
#chroot_check $? "systemd : rm -f /etc/sysctl.d/50-pid-max.conf"
#rm -fv /usr/lib/lib{blkid,uuid,mount}.so*
#chroot_check $? "systemd : rm -fv /usr/lib/lib{blkid,uuid,mount}.so*"
#rm -f /usr/lib/tmpfiles.d/systemd-nologin.conf
#chroot_check $? "systemd : rm -f /usr/lib/tmpfiles.d/systemd-nologin.conf"


