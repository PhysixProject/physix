#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1

echo 9.0-systemd > /etc/physix-release
chroot_check $? "system config : set /etc/physix-release "

cat > /etc/os-release << "EOF"
NAME="Physix"
VERSION="systemd"
ID=physix
PRETTY_NAME="Physix-systemd"
VERSION_CODENAME="Physix"
EOF
chroot_check $? "system config : set /etc/os-release"

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Physix"
DISTRIB_RELEASE="Physix-systemd"
DISTRIB_CODENAME="Physix"
DISTRIB_DESCRIPTION="Physix"
EOF
chroot_check $? "system config : set /etc/lsb-release "


