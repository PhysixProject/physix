#!/bin/bash

/sbin/chroot "/mnt/physix" /tools/bin/env -i HOME=/root  TERM="$TERM" PS1='(physix chroot) \u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin  /tools/bin/bash --login +h



