#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


2to3-3.7 -w data/autostart/openbox-xdg-autostart &&
sed 's/python/python3/' -i data/autostart/openbox-xdg-autostart


su physix -c './configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --docdir=/usr/share/doc/openbox-3.6.1'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"


make install
chroot_check $? "make install"

