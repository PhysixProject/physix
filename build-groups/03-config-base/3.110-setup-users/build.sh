#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf || exit 1

install --verbose --mode 644 --owner root --group root $PKG_DIR_PATH/etc_profile  /etc/profile
chroot_check $? "Create /etc/profile"

install --verbose --mode 644 --owner root --group root $PKG_DIR_PATH/user_profile  /root/.profile
chroot_check $? "Create /root/.profile"

install --verbose --mode 644 --owner root --group root $PKG_DIR_PATH/etc_bashrc  /root/.bashrc
chroot_check $? "Create /root/.bashrc"

if [ $CONF_GEN_USER ] ; then
	grep -q $CONF_GEN_USER /etc/passwd
	if [ $? -ne 0 ] ; then
		useradd -m $CONF_GEN_USER
		chroot_check $? "Create user $CONF_GEN_USER"

		chmod 700 /home/$CONF_GEN_USER
		chroot_check $? "chmod 700 /home/$CONF_GEN_USER"
	fi

	install --verbose --mode 644 --owner $CONF_GEN_USER --group $CONF_GEN_USER $PKG_DIR_PATH/user_profile  /home/$CONF_GEN_USER/.profile
	chroot_check $? "Create /home/$CONF_GEN_USER/.profile"

	install --verbose --mode 644 --owner $CONF_GEN_USER --group $CONF_GEN_USER $PKG_DIR_PATH/etc_bashrc  /home/$CONF_GEN_USER/.bashrc
	chroot_check $? "chown /home/$CONF_GEN_USER/.bashrc"
fi

if [ ! -e /home/physix ] ; then
	install --verbose --mode 700 --owner physix --group physix --directory /home/physix
	chroot_check $? "Create /home/physix"

	chown physix:physix /opt/admin/sources.physix
	chroot_check $? "chown physix:physix  /opt/admin/sources.physix"
fi

install --verbose --mode 700 --owner physix --group physix  $PKG_DIR_PATH/user_profile  /home/physix/.profile
chroot_check $? "setup physix profile"

install --verbose --mode 700 --owner physix --group physix  $PKG_DIR_PATH/etc_bashrc  /home/physix/.bashrc
chroot_check $? "setup physix bashrc"

