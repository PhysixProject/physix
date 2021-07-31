#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2020 Tree Davies


NR_PROC=`nproc`
N=$(($NR_PROC-1))
for i in `seq 0 $N`  ; do
	echo performance > /sys/devices/system/cpu/cpufreq/policy$i/scaling_governor
	echo -n "CPU:$i " 
	cat /sys/devices/system/cpu/cpufreq/policy$i/scaling_governor
done


