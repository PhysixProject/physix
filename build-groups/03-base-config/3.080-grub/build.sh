#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf

# This should be dynamically set.
SET_ROOT=`echo $CONF_GRUB_SET_ROOT | cut -d'=' -f2`
ROOT_DEV=`echo $CONF_ROOT_DEVICE | cut -d'=' -f2`
ROOT_PART=`echo $CONF_ROOT_PARTITION | cut -d'=' -f2`
ROOT_PART='\/dev\/'$ROOT_PART

KERNEL=`ls /boot | grep vmlinuz- | grep -e "physix.x86_64$"`
INITRD=`ls /boot | grep initrd- | grep -e "physix.x86_64$"`

if [ $CONF_SKIP_PARTITIONING == "n" ]  ; then
	# IF PARTITIONING WAS NOT SKIPPED, IT SHOULD BE SAFE TO INSTALL GRUB
	if [ $CONF_UEFI_ENABLE == "n" ] ; then
		# This might fail due to Error:'will not proceed with blocklists'
		# Can be forced with --force
		grub-install --target=i386-pc --force /dev/$ROOT_DEV
		chroot_check $? "grub-install /dev/$ROOT_DEV"
	else
		grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=PHYSIX --force /dev/$ROOT_DEV
		chroot_check $? "grub-install EFI"
	fi
fi

install --verbose --mode 644 --owner root --group root $PKG_DIR_PATH/lvm-grub.cfg  /boot/physix-grub.cfg
chroot_check $? "Install grub.cfg"

SED_CMD='s/SET_ROOT_MARKER/'$SET_ROOT'/g'
sed -i $SED_CMD /boot/physix-grub.cfg
chroot_check $? "Grub sed edit $SED_CMD physix-grub.cfg"

SED_CMD='s/VOL_GROUP_MARKER/'$CONF_VOL_GROUP_NAME'/g'
sed -i $SED_CMD /boot/physix-grub.cfg
chroot_check $? "Grub sed edit $SED_CMD physix-grub.cfg"

SED_CMD='s/KERNEL_MARKER/'$KERNEL'/g'
sed -i $SED_CMD /boot/physix-grub.cfg
chroot_check $? "Grub sed edit $SED_CMD physix-grub.cfg"

SED_CMD='s/INITRD_MARKER/'$INITRD'/g'
sed -i $SED_CMD /boot/physix-grub.cfg
chroot_check $? "Grub sed edit $SED_CMD physix-grub.cfg"

if [ $CONF_SKIP_PARTITIONING == "n" ] ; then
	# IF PARTITIONING WAS NOT SKIPPED, WE ASSUME /boot WAS 
	# CREATED AND FORMATTED BY PHYSIX, AND THUS IS SAFE TO WRITE grub.cfg
	if [ ! -e /boot/grub/grub.cfg ] ; then
		mv /boot/physix-grub.cfg /boot/grub/grub.cfg
		chroot_check $? "mv /boot/grub/physix-grub.cfg /boot/grub/grub.cfg"
	else
		echo "Found /boot/grub/grub.cfg, so will not over-write"
	fi
fi

if [ -e /boot/grub ] ; then
	install --verbose --mode 444 --owner root --group root $PKG_DIR_PATH/unicode.pf2  /boot/grub/fonts/
	chroot_check $? "install $PKG_DIR_PATH/unicode.pf2  /boot/grub/fonts/"

	install --verbose --mode 444 --owner root --group root $PKG_DIR_PATH/physix-splash.png  /boot/grub/
    chroot_check $? "install physix-splash.png /boot/grub/"
fi

