#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1


LOOP=0
while [ $LOOP -eq 0 ] ; do
	report "Set root Password"
	passwd root
	if [ $? -eq 0 ] ; then LOOP=1; fi
done
cp /physix/build-scripts.config/configs/bashrc /root/.bashrc
chroot_check $? "Create root/.bashrc"

echo "build.conf specifys a general user to be created: $CONF_GEN_USER"
useradd -m $CONF_GEN_USER
chroot_check $? "useradd -m $CONF_GEN_USER"

cp /physix/build-scripts.config/configs/bashrc /home/$CONF_GEN_USER/.bashrc
chroot_check $? "Create /home/$CONF_GEN_USER/.bashrc"

LOOP=0
while [ $LOOP -eq 0 ] ; do
        passwd $CONF_GEN_USER
        if [ $? -eq 0 ] ; then LOOP=1; fi
done

useradd -m physix
chroot_check $? "useradd  physix"
LOOP=0
while [ $LOOP -eq 0 ] ; do
        passwd physix
        if [ $? -eq 0 ] ; then LOOP=1; fi
done

