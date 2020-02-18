#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-legacy-sm'
chroot_check $? "config"

su physix 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"

update-desktop-database &&
update-mime-database /usr/share/mime
chroot_check $? "update desktop db"

