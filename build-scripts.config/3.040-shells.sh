#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 3

cp -v  /physix/build-scripts.config/configs/etc_shells /etc/shells
chroot_check $? "system config : setup /etc/shells "

