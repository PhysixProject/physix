#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2020 Tree Davies

if [ `id -u` -ne 0 ] ; then
	echo "Error: Must be run as root"
	exit 1
fi

if [ `pwd` != '/mnt/physix/opt/admin/physix' ] ; then
	echo "Error: Current Working Directory is not /mnt/physix/opt/admin/physix"
	exit 1
fi

for RECIPE in 01-base-toolchain.json 02-base-system.json 03-config-base.json ; do
	./catalyst -p $RECIPE
	if [ $? -ne 0 ] ; then
		echo "$RECIPE: Download soureces Failed"
		exit 1
	fi
done

./catalyst -t 01-base-toolchain.json
if [ $? -ne 0 ] ; then
	echo "Build Failed"
	exit 1
fi

./catalyst -s 02-base-system.json
if [ $? -ne 0 ] ; then
    echo "Build Failed"
    exit 1
fi

./catalyst -c 03-config-base.json
if [ $? -ne 0 ] ; then
    echo "Build Failed"
    exit 1
fi


