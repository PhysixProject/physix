#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1

install --verbose --mode 444 --owner root --group root  /opt/physix/build-scripts/03-base-config/configs/os-release  /etc/os-release
chroot_check $? "system config : set /etc/os-release"

install --verbose --mode 444 --owner root --group root  /opt/physix/build-scripts/03-base-config/configs/lsb-release  /etc/lsb-release
chroot_check $? "system config : set /etc/lsb-release "

