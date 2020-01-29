#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh
source /physix/build.conf

# This should be dynamically set.
SET_ROOT=`cat /physix/build.conf | grep CONF_GRUB_SET_ROOT | cut -d'=' -f2`
ROOT_DEV=`cat /physix/build.conf | grep CONF_ROOT_DEVICE | cut -d'=' -f2`
ROOT_PART=`cat /physix/build.conf | grep CONF_ROOT_PARTITION | cut -d'=' -f2`
ROOT_PART='\/dev\/'$ROOT_PART

LOOP=0
while [ $LOOP -eq 0 ] ; do
    report "\n\nTime to install Grub."
    report "build.conf specifys:"
    report "- ROOT_DEVICE: /dev/$ROOT_DEV"
    report "- GRUB sees ROOT_DEVICE as(hdX,Y): $SET_ROOT "
    report "NOTE: Grub see the root device number (hdX) as 1 less than ROOT_DEVICE number."
    report "the partition number (Y) is the same as ROOT_PARTITION's."
    report "\n"
    report "If you DO NOT wish to install grub to this device, type 'no'"
    echo -n "Install grub to /dev/$ROOT_DEV? (yes/no): "
    read CHOICE

    if [ "$CHOICE" == "yes" ] || [ "$CHOICE" == "no" ] ; then
        LOOP=1
    fi
done

if [ $CHOICE == 'yes' ] ; then
    grub-install /dev/$ROOT_DEV
    chroot_check $? "grub-install /dev/$ROOT_DEV"
else
    exit 0
fi

#if [ $CONF_USE_LVM=="y" ] ; then
	cp -v /physix/build-scripts.config/configs/lvm-grub.cfg /boot/grub/grub.cfg
	chroot_check $? "cp grub.cfg"
#fi

SED_CMD='s/SET_ROOT_MARKER/'$SET_ROOT'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"

SED_CMD='s/VAL_GROUP_MARKER/'$CONF_VOL_GROUP_MARKER'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"

if [ -e /boot/grub ] ; then
        cp -v /physix/build-scripts.config/configs/unicode.pf2 /boot/grub/fonts
	chroot_check $? "cp -v /physix/build-scripts.config/configs/unicode.pf2 /boot/grub/fonts"

        cp -v /physix/build-scripts.config/configs/physix-splash.png /boot/grub/
        chroot_check $? "cp physix-splash.png /boot/grub/"
fi


