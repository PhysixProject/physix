#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /mnt/physix/opt/admin/physix/include.sh || exit 1

PKG=$1
SOURCES=${2:-''}

chroot "$BUILDROOT" /usr/bin/env -i HOME=/root  TERM="$TERM" \
        PS1='(physix chroot) \u:\w\$ '                       \
        PATH=/bin:/usr/bin:/sbin:/usr/sbin                   \
        /bin/bash --login -c "/opt/admin/physix/build-scripts/03-base-config/$PKG/build.sh $SOURCES"

