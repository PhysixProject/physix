#!/bin/bash
source /mnt/physix/opt/admin/physix/include.sh || exit 1

SCRIPT=$1
SOURCES=${2:-''}

chroot "$BUILDROOT" /tools/bin/env -i HOME=/root  TERM="$TERM" \
        PS1='(physix chroot) \u:\w\$ '                         \
        PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin          \
        /tools/bin/bash --login +h -c "/opt/admin/physix/build-scripts/02-base/$SCRIPT $SOURCES"


