# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

export BUILDROOT='/mnt/physix'
export BR_SOURCE_DIR=$BUILDROOT/opt/sources.physix/BUILDBOX
export SOURCE_DIR=/opt/sources.physix/BUILDBOX

[ -e /mnt/physix/opt/physix/build.conf ] && source /mnt/physix/opt/physix/build.conf
[ -e /opt/physix/build.conf ] && source /opt/physix/build.conf

NPROC=`grep -e ^processor /proc/cpuinfo | wc -l`
export NPROC

function ok() {
        local MSG=$1
	local BR=''
	local TIME=`date "+%D %T"`

	if [ -r '/mnt/physix/opt/logs.physix/' ] && [ -r '/mnt/physix/opt/physix/' ] ; then
		BR=$BUILDROOT
	fi

        echo -e "\e[92m[OK]\e[0m   $TIME : $MSG"
        #echo -e "[OK] $TIME : $MSG" >> $BR/opt/physix/logs.physix/physix-build.log
}


function error() {
        local MSG=$1
	local BR=''

	if [ -r '/mnt/physix/opt/logs.physix/' ] && [ -r '/mnt/opt/physix/' ] ; then
		BR=$BUILDROOT
	fi

        echo -e "\e[31m[ERROR]\e[0m $TIME :$MSG"
	#echo -e "[ERROR] $TIME : $MSG" >> $BR/opt/physix/logs.physix/physix-build.log
        #echo -e "[ERROR] $TIME : $MSG" >> $BR/var/physix/system-build-logs/build.log
}

# Check, handle and log return code
# used for scripts executed 'within' chroot'd envs
function chroot_check() {
	local RTN=$1
	local MSG=$2
	local NOEXIT=${3:-"FALSE"}
	if [ $RTN -ne 0 ] ; then
		error "$RTN:$MSG"
		if [ $NOEXIT == "FALSE" ] ; then
			exit 1
		fi
	else
		ok "$MSG"
		return 0
	fi
}


# Check, handle and log return code
# used for scripts executed outside chroot'd envs
function check() {
	local RTN=$1
	local MSG=$2
	local NOEXIT=${3:-"FALSE"}
	local BR=''
	if [ $RTN -ne 0 ] ; then
		error "$RTN:$MSG"
		if [ $NOEXIT == "FALSE" ] ; then
			exit 1
		fi
	else
		ok "$MSG"
		return 0
	fi
}



