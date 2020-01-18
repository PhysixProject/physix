#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 3
source /physix/build.conf || exit 1

echo $CONF_HOSTNAME > /etc/hostname
chroot_check $? "system config : Set hostname from build.conf "

