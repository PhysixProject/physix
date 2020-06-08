#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


su physix -c 'gzip -cd ../../libpng-1.6.37-apng.patch.gz | patch -p1'
chroot_check $? "gzip"

su physix -c './configure --prefix=/usr --disable-static'
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make install &&
mkdir -pv /usr/share/doc/libpng-1.6.37 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.37
chroot_check $? "make install"

