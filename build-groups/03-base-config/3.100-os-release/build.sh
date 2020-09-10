#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/admin/physix/include.sh || exit 1

install --verbose --mode 444 --owner root --group root  $PKG_DIR_PATH/os-release  /etc/os-release
chroot_check $? "system config : set /etc/os-release"

install --verbose --mode 444 --owner root --group root  $PKG_DIR_PATH/lsb-release  /etc/lsb-release
chroot_check $? "system config : set /etc/lsb-release"

install --verbose --mode 444 --owner root --group root /opt/admin/physix/physix.conf /etc/physix.conf
chroot_check $? "Install /etc/physix.conf"

