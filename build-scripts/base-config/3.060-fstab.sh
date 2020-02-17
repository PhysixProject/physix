#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1

BOOT=`blkid /dev/"$CONF_ROOT_DEVICE"2 | cut -d'"' -f2`

cp -v /physix/build-scripts/base-config/configs/etc_fstab /etc/fstab
chroot_check $? "system config : cp -v etc_fstab /etc/fstab "

SED_CMD='s/BOOT_UUID_MARKER/'$BOOT'/g'
sed -i $SED_CMD /etc/fstab
chroot_check $? "sed -i $SED_CMD /etc/fstab"

if [ $CONF_ROOTPART_FS ] ; then
	SED_CMD='s/FS_MARKER/'$CONF_ROOTPART_FS'/g'
else
	SED_CMD='s/FS_MARKER/'ext4'/g'
fi
sed -i $SED_CMD /etc/fstab
chroot_check $? "sed -i $SED_CMD /etc/fstab"

SED_CMD='s/VOL_GROUP_MARKER/'$CONF_VOL_GROUP_NAME'/g'
sed -i $SED_CMD /etc/fstab
chroot_check $? "fstab sed edit $SED_CMD"

