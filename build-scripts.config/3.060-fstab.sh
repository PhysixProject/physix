#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

ROOT_PART=`cat /physix/build.conf | grep CONF_ROOT_PARTITION | cut -d'=' -f2`
ROOT_PART='\/dev\/'$ROOT_PART
FS_FORMAT=`cat /physix/build.conf | grep CONF_FS_FORMAT | cut -d'=' -f2`

cp -v /physix/build-scripts.config/etc_fstab /etc/fstab
chroot_check $? "system config : cp -v etc_fstab /etc/fstab "

SED_CMD='s/REPLACE_MARKER_STR/'$ROOT_PART'/g'
sed -i $SED_CMD /etc/fstab
chroot_check $? "sed -i $SED_CMD /etc/fstab"

SED_CMD='s/REPLACE_MARKER_FS/'$FS_FORMAT'/g'
sed -i $SED_CMD /etc/fstab
chroot_check $? "sed -i $SED_CMD /etc/fstab"
