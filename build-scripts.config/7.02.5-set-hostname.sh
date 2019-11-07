#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

HN=`cat /physix/build.conf | grep HOSTNAME | cut -d'=' -f2`
echo $HN > /etc/hostname
chroot_check $? "system config : Set hostname from build.conf "

