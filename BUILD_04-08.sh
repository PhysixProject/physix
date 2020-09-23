#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2020 Tree Davies

if [ `id -u` -ne 0 ] ; then
	echo "Error: Must be run as root"
	exit 1
fi

if [ `pwd` != '/opt/admin/physix' ] ; then
	echo "Error: Current Working Directory is not /opt/admin/physix"
	exit 1
fi

make-ca -g
if [ $? -ne 0 ] ; then
	echo "make-ca failure"
	exit 1
fi


for RECIPE in  04-utilities.json 05-services.json 05-testing.json 05-xorg.json 06-lightdm.json 07-lxde.json 08-xapps.json ; do
	./catalyst -p $RECIPE
	if [ $? -ne 0 ] ; then
		echo "$RECIPE: Download soureces Failed"
		exit 1
	fi
done

./catalyst -r INITIAL_BOOT
./catalyst -b 04-utilities.json
if [ $? -ne 0 ] ; then
	echo "Build Failed"
	exit 1
fi

./catalyst -r SNAP_B
./catalyst -b 05-services.json
if [ $? -ne 0 ] ; then
    echo "Build Failed"
    exit 1
fi

./catalyst -r SNAP_C
./catalyst -b 05-testing.json
if [ $? -ne 0 ] ; then
    echo "Build Failed"
    exit 1
fi

./catalyst -r SNAP_D
./catalyst -b 05-xorg.json
if [ $? -ne 0 ] ; then
    echo "Build Failed"
    exit 1
fi

./catalyst -r SNAP_E
./catalyst -b 06-lightdm.json
if [ $? -ne 0 ] ; then
    echo "Build Failed"
    exit 1
fi

./catalyst -r SNAP_F
./catalyst -b 07-lxde.json
if [ $? -ne 0 ] ; then
    echo "Build Failed"
    exit 1
fi

./catalyst -r SNAP_G
./catalyst -b 08-xapps.json
if [ $? -ne 0 ] ; then
    echo "Build Failed"
    exit 1
fi

./catalyst -r SNAP_H

