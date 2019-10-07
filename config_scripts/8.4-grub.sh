#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

# This should be dynamically set.
ROOT_DEV=`cat /physix/build.conf | grep ROOT_DEVICE | cut -d'=' -f2`
ROOT_PART=`cat /physix/build.conf | grep ROOT_PARTITION | cut -d'=' -f2`
ROOT_PART='\/dev\/'$ROOT_PART

LOOP=0
while [ $LOOP -eq 0 ] ; do
    echo -e "\n\nTime to install Grub."
    echo "build.conf specifys /dev/$ROOT_DEV as your root storage device." 
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
set root=(hd0,1)

menuentry "GNU/Linux, Linux 5.2.8-lfs-9.0-systemd" { 
        linux   /boot/vmlinuz-5.2.8-lfs-9.0-systemd root=REPLACE_MARKER ro
}
EOF
chroot_check $? "system config: grub : Grub /boot/grub/grub.cfg"

SED_CMD='s/REPLACE_MARKER/'$ROOT_PART'/g'
sed -i $SED_CMD /boot/grub/grub.cfg
chroot_check $? "Grub sed edit $SED_CMD grub.cfg"


