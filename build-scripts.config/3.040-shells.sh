#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 3

cp -v  /physix/build-scripts.config/configs/etc_shells /etc/shells
chroot_check $? "Setup /etc/shells"

cp /physix/build-scripts.config/configs/etc_bashrc /etc/bashrc
chroot_check $? "Ssetup /etc/bashrc"

mkdir -p /etc/profile.d/
chroot_check $? "Setup /etc/profile.d/"

