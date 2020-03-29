#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1

# This should be dynamically set.
SET_ROOT=`echo $CONF_GRUB_SET_ROOT | cut -d'=' -f2`
ROOT_DEV=`echo $CONF_ROOT_DEVICE | cut -d'=' -f2`
ROOT_PART=`echo $CONF_ROOT_PARTITION | cut -d'=' -f2`
ROOT_PART='\/dev\/'$ROOT_PART


grub-install /dev/$ROOT_DEV
chroot_check $? "grub-install /dev/$ROOT_DEV"

cp -v /opt/physix/build-scripts/03-base-config/configs/lvm-grub.cfg /boot/grub/grub.cfg
chroot_check $? "cp grub.cfg"

SED_CMD='s/SET_ROOT_MARKER/'$SET_ROOT'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"

SED_CMD='s/VOL_GROUP_MARKER/'$CONF_VOL_GROUP_NAME'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"

if [ -e /boot/grub ] ; then
        cp -v /opt/physix/build-scripts/03-base-config/configs/unicode.pf2 /boot/grub/fonts
	chroot_check $? "cp -v /physix/build-scripts.config/configs/unicode.pf2 /boot/grub/fonts"

        cp -v /opt/physix/build-scripts/03-base-config/configs/physix-splash.png /boot/grub/
        chroot_check $? "cp physix-splash.png /boot/grub/"
fi


