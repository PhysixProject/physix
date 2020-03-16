#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'patch -Np1 -i ../libxslt-1.1.33-security_fix-1.patch'
chroot_check $? "make install"

su physix -c 'sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml}'
chroot_check $? "sed"

su physix -c './configure --prefix=/usr --disable-static'
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"

