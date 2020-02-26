#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 3

cp -v /opt/physix/build-scripts/03-base-config/configs/etc_shells /etc/shells
chroot_check $? "Setup /etc/shells"

cp /opt/physix/build-scripts/03-base-config/configs/etc_bashrc /etc/bashrc
chroot_check $? "Ssetup /etc/bashrc"

mkdir -p /etc/profile.d/
chroot_check $? "Setup /etc/profile.d/"

