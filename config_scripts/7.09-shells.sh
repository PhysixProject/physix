#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

cp -v  /physix/config_scripts/etc_shells /etc/shells
chroot_check $? "system config : setup /etc/shells "

