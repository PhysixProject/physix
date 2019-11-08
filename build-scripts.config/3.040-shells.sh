#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

cp -v  /physix/build-scripts.config/etc_shells /etc/shells
chroot_check $? "system config : setup /etc/shells "

