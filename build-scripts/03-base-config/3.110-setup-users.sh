#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1

#keep
cp -v /opt/physix/build-scripts/03-base-config/configs/etc_profile /etc/profile
chroot_check $? "Create /etc/profile"

#keep
cp -v /opt/physix/build-scripts/03-base-config/configs/user_profile /root/.profile
chroot_check $? "Create /root/.profile"

#keep
cp -v /opt/physix/build-scripts/03-base-config/configs/etc_bashrc /root/.bashrc
chroot_check $? "Create /root/.bashrc"

if [ $CONF_GEN_USER ] ; then
	grep -q $CONF_GEN_USER /etc/passwd
	if [ $? -ne 0 ] ; then
		useradd -m $CONF_GEN_USER
		chroot_check $? "Create user $CONF_GEN_USER"
	fi

	cp /opt/physix/build-scripts/03-base-config/configs/user_profile /home/$CONF_GEN_USER/.profile
	chroot_check $? "Create /home/$CONF_GEN_USER/.profile"
	chown $CONF_GEN_USER:$CONF_GEN_USER /home/$CONF_GEN_USER/.profile
	chroot_check $? "chown /home/$CONF_GEN_USER/.profile"

	cp /opt/physix/build-scripts/03-base-config/configs/etc_bashrc /home/$CONF_GEN_USER/.bashrc
	chroot_check $? "Create /home/$CONF_GEN_USER/.bashrc"
	chown $CONF_GEN_USER:$CONF_GEN_USER /home/$CONF_GEN_USER/.bashrc
	chroot_check $? "chown /home/$CONF_GEN_USER/.bashrc"
fi

grep -q physix /etc/passwd
if [ $? -ne 0 ] ; then
	#TODO: useradd -m -u 6000 physix
	useradd -m physix
	chroot_check $? "useradd physix"

	cp /opt/physix/build-scripts/03-base-config/configs/user_profile /home/physix/.profile &&
	chown physix:physix /home/physix/.profile
	chroot_check $? "setup physix profile"

	cp /opt/physix/build-scripts/03-base-config/configs/etc_bashrc /home/physix/.bashrc &&
	chown physix:physix /home/physix/.bashrc
	chroot_check $? "setup physix bashrc"
fi

