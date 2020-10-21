#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf || exit 1

BOOT=`blkid /dev/"$CONF_BOOT_DEV_PART" | cut -d'"' -f2`
EFI_BOOT=`blkid /dev/"$CONF_UEFI_DEV_PART" | cut -d'"' -f2`


if [ "$CONF_UEFI_ENABLE" == "y" ] ; then
	install --verbose --mode 644 --owner root --group root $PKG_DIR_PATH/etc_efi_fstab  /etc/fstab
	chroot_check $? "install /etc/fstab"

	SED_CMD='s/BOOT_EFI_UUID_MARKER/'$EFI_BOOT'/g'
	sed -i $SED_CMD /etc/fstab
	chroot_check $? "sed -i $SED_CMD /etc/fstab"
else
	install --verbose --mode 644 --owner root --group root $PKG_DIR_PATH/etc_fstab  /etc/fstab 
	chroot_check $? "install /etc/fstab"
fi


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




