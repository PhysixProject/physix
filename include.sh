# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

export BUILDROOT='/mnt/physix'
export BR_SOURCE_DIR=$BUILDROOT/opt/sources.physix/BUILDBOX
#export SOURCE_DIR=/usr/src/physix/sources
export SOURCE_DIR=/opt/sources.physix/BUILDBOX
#export LOG_DIR=/var/log/physix/build-logs/

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


# Used by 3-config-base-sys.sh and beyond
# Runs build scripts under /bin/bash
function chroot-conf-build {
	local SPATH=$1
	local SCRIPT=$2
	local PKG=${3:-''}
	local IO=${4:-''}
	local IO_DIRECTION=''
	local TIME=`date "+%Y-%m-%d-%T" | tr ":" "-"`

	if [ "$IO" == 'log' ] ; then
		IO_DIRECTION="&> /var/physix/system-build-logs/$TIME-$SCRIPT"
	else
		IO_DIRECTION="| tee /var/physix/system-build-logs/$TIME-$SCRIPT"
	fi

	chroot "$BUILDROOT" /tools/bin/env -i HOME=/root  TERM="$TERM" \
		PS1='(physix chroot) \u:\w\$ '                         \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin                     \
		/bin/bash --login -c "/physix/build-scripts/03-base-config/$SCRIPT $PKG $IO_DIRECTION"
}


# Used by 2-build-base-sys.sh
# Runs build scripts under /tools/bin/bash
function chroot-build {
	local SPATH=$1
	local SCRIPT=$2
	local SRC0=${3:-''}
	local SRC1=${4:-''}
	local TIME=`date "+%Y-%m-%d-%T" | tr ":" "-"`

	chroot "$BUILDROOT" /tools/bin/env -i HOME=/root  TERM="$TERM" \
		PS1='(physix chroot) \u:\w\$ '                         \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin          \
		/tools/bin/bash --login +h -c "/physix/build-scripts/02-base/$SCRIPT $SRC0 $SRC1 &> /var/physix/system-build-logs/$TIME-$SCRIPT"

}


# Download sources packages
function pull_sources() {
	local LIST=$1
	local DEST_DIRECTORY=${2:-'/usr/src/physix/sources/'}
        local ERROR=0

	if [ ! -d $DEST_DIRECTORY ] ; then
		mkdir -vp $DEST_DIRECTORY
	fi

        echo -e "\n\nDownloading $LIST Sources..."
        for LINE in `cat $LIST | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
		local PKG_NAME=`echo $LINE | cut -d, -f1`
		local PKG_URL=`echo $LINE | cut -d, -f2`
		local PKG_MD5=`echo $LINE | cut -d, -f3`
		echo "PKG_NAME $PKG_NAME"
		echo "PKG_URL $PKG_URL"
		echo "DESTINATION $DEST_DIRECTORY"
		echo "PKG_MD5 $PKG_MD5"

                wget -q --continue --directory-prefix=$DEST_DIRECTORY $PKG_URL
                if [ $? -ne 0 ] ; then
                        echo -e "\e[31m[ ERROR ]\e[0m Downloading $PKG_URL"
                        ERROR=1
                else
                        echo -e "\e[92m[ OK ]\e[0m Downloading $PKG_URL"
                fi
		
		if [ -e $DEST_DIRECTORY/$PKG_NAME ] ; then
			C=`md5sum $DEST_DIRECTORY/$PKG_NAME | cut -d' ' -f1`
			if [ "$PKG_MD5" == "$C" ] ; then
		        	echo -e "\e[92m[ OK ]\e[0m MD5-check $PKG_NAME : $PKG_MD5"
			else
		        	echo -e "\e[31m[ ERROR ]\e[0m MD5-Check $PKG_NAME : $PKG_MD5"
				echo -e "  Expected:$PKG_MD5  Found:$C"
				echo "[FAIL] CHECK YOUR SOURCES! At lease 1 package is not Authentic."
		        	ERROR=1
			fi
		else
			echo "[ ERROR ] NOT FOUND: $DEST_DIRECTORY/$PKG_NAME  "	
		fi

        done
        return $ERROR
}


