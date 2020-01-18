#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh

IAM=`whoami`
if [ "$IAM" != "root" ] ; then
    report "Must run this as user: root, Exiting..."
    exit 1
fi


report "___  _  _ _   _ ____ _ _  _ "
report "|__] |__|  \_/  [__  |  \/  "
report "|    |  |   |   ___] | _/\_ "
report "____ _  _ _  _   / _    _ _  _ _  _ _  _ "
report "| __ |\ | |  |  /  |    | |\ | |  |  \/  "
report "|__] | \| |__| /   |___ | | \| |__| _/\_ "
report "STAGE-2-INSTALL.sh"

cd /physix/
check $? "cd -v /physix"

./4-build-utils.sh
check $? "4-build-utils.sh"

./5-build-devel.sh
check $? "5-build-devel.sh"

report "-------------------------------------------------------------"
report "- STAGE-2-INSTALL Complete                                  -"
report "-------------------------------------------------------------"

