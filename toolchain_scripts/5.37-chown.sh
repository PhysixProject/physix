#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /mnt/lfs/physix/include.sh
source ~/.bashrc

chown -R root:root $LFS/tools
check $? "chown -R root:root $LFS/tools"

