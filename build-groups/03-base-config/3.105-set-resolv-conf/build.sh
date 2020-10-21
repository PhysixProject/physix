#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf

if [ -e /etc/resolv.conf ] ; then
	rm /etc/resolv.conf && echo "nameserver $CONF_NAMESERVER" >> /etc/resolv.conf
	chroot_check $? "Setup resolv.conf"
else
	echo "nameserver $CONF_NAMESERVER" >> /etc/resolv.conf
	chroot_check $? "Setup resolv.conf"
fi

