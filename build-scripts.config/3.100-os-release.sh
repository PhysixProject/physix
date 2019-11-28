#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

echo 9.0-systemd > /etc/physix-release
chroot_check $? "system config : set /etc/lfs-release "

cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="9.0-systemd"
ID=lfs
PRETTY_NAME="Linux From Scratch 9.0-systemd"
VERSION_CODENAME="Physix"
EOF
chroot_check $? "system config : set /etc/os-release"

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="9.0-systemd"
DISTRIB_CODENAME="Physix"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF
chroot_check $? "system config : set /etc/lsb-release "


