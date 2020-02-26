#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /top/physix/include.sh

rm -rf /tools 
chroot_check $? "Removing /tools"

