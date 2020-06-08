#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

if [ -L /etc/systemd/system/default.target ] ; then
        rm /etc/systemd/system/default.target
	chroot_check $? "rm link to default.target"
fi

ln -s  /lib/systemd/system/graphical.target /etc/systemd/system/default.target
chroot_check $? "link default.target"

