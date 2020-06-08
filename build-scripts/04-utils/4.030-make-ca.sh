#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

make install &&
install -vdm755 /etc/ssl/local
chroot_check $? "make-ca : make install"

#run if re-installing
/usr/sbin/make-ca -g
chroot_check $? "make-ca : /usr/sbin/make-ca -g"

