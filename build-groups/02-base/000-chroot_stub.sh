#!/bin/bash
source /mnt/physix/opt/admin/physix/include.sh || exit 1

PKG=$1
SOURCES=${2:-''}

chroot "$BUILDROOT" /tools/bin/env -i HOME=/root  TERM="$TERM" \
        PS1='(physix chroot) \u:\w\$ '                         \
        PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin          \
        /tools/bin/bash --login +h -c "/opt/admin/physix/build-groups/02-base/$PKG/build.sh $SOURCES"


