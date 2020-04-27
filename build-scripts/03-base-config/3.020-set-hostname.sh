#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1

if [ $CONF_HOSTNAME ] ; then
	echo $CONF_HOSTNAME > /etc/hostname
	chroot_check $? "system config : Set hostname from physix.conf to $CONF_HOSTNAME"
else
	echo 'physix'  > /etc/hostname
	chroot_check $? "system config : Set Default hostname to 'physix'"
fi

