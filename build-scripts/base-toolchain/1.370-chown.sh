#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../../include.sh
source ~/.bashrc

chown -R root:root $BUILDROOT/tools
check $? "chown -R root:root $BUILDROOT/tools"

