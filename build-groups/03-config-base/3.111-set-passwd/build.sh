#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf || exit 1

passwd root
chroot_check $? "Set root passwd"

passwd $CONF_GEN_USER
chroot_check $? "set $CONF_GEN_USER passwd"

