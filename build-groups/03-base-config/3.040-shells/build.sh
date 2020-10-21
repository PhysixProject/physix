#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 3

install --verbose --mode 644 --owner root --group root $PKG_DIR_PATH/etc_shells  /etc/shells
chroot_check $? "Setup /etc/shells"

install --verbose --mode 644 --owner root --group root $PKG_DIR_PATH/etc_bashrc  /etc/bashrc
chroot_check $? "Ssetup /etc/bashrc"

install --verbose --mode 655 --owner root --group root --directory /etc/profile.d/
chroot_check $? "Setup /etc/profile.d/"

