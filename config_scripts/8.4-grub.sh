#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

# This should be dynamically set.
SET_ROOT=`cat /physix/build.conf | grep GRUB_SET_ROOT | cut -d'=' -f2`
ROOT_DEV=`cat /physix/build.conf | grep ROOT_DEVICE | cut -d'=' -f2`
ROOT_PART=`cat /physix/build.conf | grep ROOT_PARTITION | cut -d'=' -f2`
ROOT_PART='\/dev\/'$ROOT_PART

LOOP=0
while [ $LOOP -eq 0 ] ; do
    echo -e "\n\nTime to install Grub." 
    echo "build.conf specifys:" 
    echo "- ROOT_DEVICE: /dev/$ROOT_DEV"
    echo "- ROOT_PARTITION: $ROOT_PARTITION"
    echo "- GRUB sees ROOT_DEVICE as(hdX,Y): $SET_ROOT "
    echo "NOTE: Grub see the root device number (hdX) as 1 less than ROOT_DEVICE number."
    echo "the partition number (Y) is the same as ROOT_PARTITION's."
    echo -e "\n"
    echo "If you DO NOT wish to install grub to this device, type 'no'" 
    echo -n "Install grub to /dev/$ROOT_DEV? (yes/no): "
    read CHOICE 

    if [ "$CHOICE" == "yes" ] || [ "$CHOICE" == "no" ] ; then
        LOOP=1
    fi
done

if [ $CHOICE == 'yes' ] ; then
    grub-install /dev/$ROOT_DEV 
    chroot_check $? "system config: grub : grub-install /dev/$ROOT_DEV"
fi

cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=SET_ROOT_MARKER

if loadfont unicode; then
  set gfxmode=auto
  insmod vbe
  insmod vga
  insmod gfxterm
  set locale_dir=/boot/grub/locale
  set lang=en_US
  insmod gettext
  terminal_output gfxterm

  insmod png
  background_image /boot/grub/physix.gray.png
fi

menuentry "GNU/Linux, Linux 5.2.8-lfs-9.0-systemd" { 
        linux   /boot/vmlinuz-5.2.8-lfs-9.0-systemd root=ROOT_PART_MARKER ro
}
EOF
chroot_check $? "system config: grub : Grub /boot/grub/grub.cfg"

SED_CMD='s/ROOT_PART_MARKER/'$ROOT_PART'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"

SED_CMD='s/SET_ROOT_MARKER/'$SET_ROOT'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"

if [ -e /boot/grub ] ; then
        cp -v /physix/config_scripts/unicode.pf2 /boot/grub/fonts
        cp -v /physix/config_scripts/physix.gray.png /boot/grub/
        chroot_check $? "cp physix.gray.png /boot/grub/"
fi

