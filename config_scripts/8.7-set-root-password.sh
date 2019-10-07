#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

LOOP=0
while [ $LOOP -eq 0 ] ; do
	echo "Set root Password"
	passwd root
	if [ $? -eq 0 ] ; then LOOP=1; fi
done


