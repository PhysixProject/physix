#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c 'patch -Np1 -i ../autoconf-2.13-consolidated_fixes-1.patch '
chroot_check $? "patch"

su physix -c "mv -v autoconf.texi autoconf213.texi  && rm -v autoconf.info"
chroot_check $? "adjust key files"

su physix -c './configure --prefix=/usr --program-suffix=2.13'
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make install                                      &&
install -v -m644 autoconf213.info /usr/share/info &&
install-info --info-dir=/usr/share/info autoconf213.info
chroot_check $? "make install"

