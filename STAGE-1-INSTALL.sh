#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source ./include.sh

IAM=`whoami`
if [ "$IAM" != "root" ] ; then
    echo "Must run this as user: root"
    echo "exiting..."
    exit 1
fi


echo "___  _  _ _   _ ____ _ _  _ "
echo "|__] |__|  \_/  [__  |  \/  "
echo "|    |  |   |   ___] | _/\_ "
echo "____ _  _ _  _   / _    _ _  _ _  _ _  _ "
echo "| __ |\ | |  |  /  |    | |\ | |  |  \/  "
echo "|__] | \| |__| /   |___ | | \| |__| _/\_ "
echo ""

./0-init-prep.sh
check $? "0-init-prep.sh -s : Get sources, lfs user setup"

cd $BUILDROOT/physix/

./1-build_toolchain.sh
check $? "1-build_toolchain.sh"

./2-build-base-sys.sh
check $? "2-build-base-sys.sh"

./3-config-base-sys.sh
check $? "3-config-base-sys.sh"

echo "Build Complete"
echo "Reboot the system from the device specifed in build.conf"

