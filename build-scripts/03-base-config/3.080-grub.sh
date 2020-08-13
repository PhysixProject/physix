#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf

# This should be dynamically set.
SET_ROOT=`echo $CONF_GRUB_SET_ROOT | cut -d'=' -f2`
ROOT_DEV=`echo $CONF_ROOT_DEVICE | cut -d'=' -f2`
ROOT_PART=`echo $CONF_ROOT_PARTITION | cut -d'=' -f2`
ROOT_PART='\/dev\/'$ROOT_PART

KERNEL=`ls /boot | grep vmlinuz-`
INITRD=`ls /boot | grep initrd-`

if [ $CONF_UEFI_ENABLE == "n" ] ; then
	# This might fail due to Error:'will not proceed with blocklists'
	# Can be forced with --force
	grub-install --target=i386-pc --force /dev/$ROOT_DEV
	chroot_check $? "grub-install /dev/$ROOT_DEV"
else
	grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=PHYSIX --force /dev/$ROOT_DEV
	chroot_check $? "grub-install EFI"
fi

install --verbose --mode 644 --owner root --group root /opt/admin/physix/build-scripts/03-base-config/configs/lvm-grub.cfg  /boot/grub/grub.cfg
chroot_check $? "Install grub.cfg"

SED_CMD='s/SET_ROOT_MARKER/'$SET_ROOT'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"

SED_CMD='s/VOL_GROUP_MARKER/'$CONF_VOL_GROUP_NAME'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"

SED_CMD='s/KERNEL_MARKER/'$KERNEL'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"

SED_CMD='s/INITRD_MARKER/'$INITRD'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"

if [ -e /boot/grub ] ; then
	install --verbose --mode 444 --owner root --group root /opt/admin/physix/build-scripts/03-base-config/configs/unicode.pf2  /boot/grub/fonts/
	chroot_check $? "install /physix/build-scripts.config/configs/unicode.pf2 /boot/grub/fonts"

	install --verbose --mode 444 --owner root --group root /opt/admin/physix/build-scripts/03-base-config/configs/physix-splash.png  /boot/grub/
    chroot_check $? "install physix-splash.png /boot/grub/"
fi

