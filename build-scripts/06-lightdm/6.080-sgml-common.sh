#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


su physix -c 'patch -Np1 -i ../sgml-common-0.6.3-manpage-1.patch'
chroot_check $? "patch"

su physix -c 'autoreconf -f -i'
chroot_check $? "autoreconf"

su physix -c './configure --prefix=/usr --sysconfdir=/etc'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make docdir=/usr/share/doc install &&
install-catalog --add /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&
install-catalog --add /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat
chroot_check $? "make install"

