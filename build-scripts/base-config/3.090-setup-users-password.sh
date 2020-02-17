#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1


LOOP=0
while [ $LOOP -eq 0 ] ; do
	report "Set root Password"
	passwd root
	if [ $? -eq 0 ] ; then LOOP=1; fi
done

cp /physix/build-scripts/base-config/configs/etc_profile /etc/profile
chroot_check $? "Create /etc/profile"

cp /physix/build-scripts/base-config/configs/user_profile /root/.profile
chroot_check $? "Create /root/.profile"

cp /physix/build-scripts/base-config/configs/etc_bashrc /root/.bashrc
chroot_check $? "Create /root/.bashrc"

if [ $CONF_GEN_USER ] ; then
	echo "build.conf specifys a general user to be created: $CONF_GEN_USER"
	grep -q travis /etc/passwd
	if [ $? -ne 0 ] ; then
		useradd -m $CONF_GEN_USER
		chroot_check $? "useradd -m $CONF_GEN_USER"
	fi

	cp /physix/build-scripts/base-config/configs/user_profile /home/$CONF_GEN_USER/.profile
	chroot_check $? "Create /home/$CONF_GEN_USER/.profile"
	chown $CONF_GEN_USER:$CONF_GEN_USER /home/$CONF_GEN_USER/.profile
	chroot_check $? "chown /home/$CONF_GEN_USER/.profile"

	cp /physix/build-scripts/base-config/configs/etc_bashrc /home/$CONF_GEN_USER/.bashrc
	chroot_check $? "Create /home/$CONF_GEN_USER/.bashrc"
	chown $CONF_GEN_USER:$CONF_GEN_USER /home/$CONF_GEN_USER/.bashrc
	chroot_check $? "chown /home/$CONF_GEN_USER/.bashrc"

	LOOP=0
	while [ $LOOP -eq 0 ] ; do
	        passwd $CONF_GEN_USER
		if [ $? -eq 0 ] ; then LOOP=1; fi
	done
fi

grep -q physix /etc/passwd
if [ $? -ne 0 ] ; then
	useradd -m physix
	chroot_check $? "useradd physix"

	cp /physix/build-scripts/base-config/configs/user_profile /home/physix/.profile &&
	chown physix:physix /home/physix/.profile
	chroot_check $? "setup physix profile"

	cp /physix/build-scripts/base-config/configs/etc_bashrc /home/physix/.bashrc &&
	chown physix:physix /home/physix/.bashrc
	chroot_check $? "setup physix bashrc"
fi

