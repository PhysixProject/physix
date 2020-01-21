#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

make install &&
install -vdm755 /etc/ssl/local
chroot_check $? "make-ca : make install"

#run if re-installing
/usr/sbin/make-ca -g
chroot_check $? "make-ca : /usr/sbin/make-ca -g"

