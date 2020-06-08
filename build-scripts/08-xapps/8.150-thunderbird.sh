#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'cp /opt/admin/physix/build-scripts/08-xapps/configs/thunderbird/mozconfig .'
chroot_check $? 'Write config'

su physix -c 'source /etc/profile.d/rustc.sh && ./mach build'
chroot_check $? 'mach build'

./mach install
chroot_check $? 'mach install'

