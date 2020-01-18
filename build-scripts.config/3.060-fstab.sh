#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
source /physix/build.conf || exit 2

BOOT=`blkid /dev/"$CONF_ROOT_DEVICE"2 | cut -d'"' -f2`

cp -v /physix/build-scripts.config/configs/etc_fstab /etc/fstab
chroot_check $? "system config : cp -v etc_fstab /etc/fstab "

SED_CMD='s/BOOT_UUID_MARKER/'$BOOT'/g'
sed -i $SED_CMD /etc/fstab
chroot_check $? "sed -i $SED_CMD /etc/fstab"

