#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'patch -Np1 -i ../libxslt-1.1.33-security_fix-1.patch'
su physix -c 'sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml}'
su physix -c './configure --prefix=/usr --disable-static'
chroot_check $? "libxslt : configure"

su physix -c 'make'
chroot_check $? "libxslt : make"

make install
chroot_check $? "libxslt : make install"

