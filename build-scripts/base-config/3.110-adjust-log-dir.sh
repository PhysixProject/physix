#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

/var/physix/system-build-logs/

mkdir /var/physix/system-build-logs/install.logs &&
mv /var/physix/system-build-logs/* /var/physix/system-build-logs/install.logs
chroot_check $? "move install logs to /var/physix/system-build-logs/install.logs"

cp /var/physix/system-build-logs/install.logs/build.log /var/physix/system-build-logs/
chroot_check $? "system config : set /etc/physix-release"

