#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

ln -sf /tools/bin/true /usr/bin/xsltproc
chroot_check $? "systemd : ln -sf /tools/bin/true /usr/bin/xsltproc"


tar -xf ../systemd-man-pages-246.tar.xz
chroot_check $? "systemd : tar -xf manpages"

sed '177,$ d' -i src/resolve/meson.build
chroot_check $? "error 1"

sed -i 's/GROUP="render", //' rules.d/50-udev-default.rules.in
chroot_check $? "error 2"


mkdir -p build
cd       build

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
      -Dhomed=false                \
      -Duserdb=false               \
      -Dman=true                   \
      -Ddocdir=/usr/share/doc/systemd-246 \
      ..
chroot_check $? "systemd : configure"

LANG=en_US.UTF-8 ninja
chroot_check $? "systemd : ninhja"

LANG=en_US.UTF-8 ninja install
chroot_check $? "systemd : ninja install"

rm -f /usr/bin/xsltproc
chroot_check $? "systemd : rm -f /usr/bin/xsltproc"

systemd-machine-id-setup
chroot_check $? "systemd : systemd-machine-id-setup"

systemctl preset-all
chroot_check $? "systemd : systemctl preset-all"

systemctl disable systemd-time-wait-sync.service
chroot_check $? "systemd : disable systemd-time-wait-sync.service"

rm -f /etc/sysctl.d/50-pid-max.conf
chroot_check $? "systemd : rm -f /etc/sysctl.d/50-pid-max.conf"
#rm -fv /usr/lib/lib{blkid,uuid,mount}.so*
#chroot_check $? "systemd : rm -fv /usr/lib/lib{blkid,uuid,mount}.so*"
#rm -f /usr/lib/tmpfiles.d/systemd-nologin.conf
#chroot_check $? "systemd : rm -f /usr/lib/tmpfiles.d/systemd-nologin.conf"

#By Default systemd install links default to graphical.target
unlink /lib/systemd/system/default.target
ln -s  /lib/systemd/system/multi-user.target /etc/systemd/system/default.target

#sed -i 's/#Storage=.*/Storage=persistent/' /etc/systemd/journald.conf
#chroot_check $? "journald set to persist logs"

