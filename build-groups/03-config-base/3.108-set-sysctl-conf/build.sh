#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf

if [ ! -e /etc/sysctl.d ] ; then
	install --verbose --mode 755 --directory /etc/sysctl.d
fi

install --verbose --mode 444 --owner root --group root  $PKG_DIR_PATH/printk.conf  /etc/sysctl.d/
chroot_check $? "Setup printk sysctl"

