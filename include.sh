# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

export BUILDROOT='/mnt/physix'
NPROC=`grep -e ^processor /proc/cpuinfo | wc -l`
export NPROC

function verify_tools() {
	echo "Looking for required tools on host systemd..."
	for TOOL in mkfs.ext3 gcc g++ make gawk bison ; do
		which $TOOL
		if [ $? -ne 0 ] ; then
			echo "$TOOL Not Found."
			exit 1
		fi
	done
}

function report() {
	local MSG=$1
	local NO_NEW_LINE=$2
	local BR=''

	echo -e "\e[93m[INFO]\e[0m $MSG"

	# chroot context
	if [ -r /var/physix/system-build-logs/build.log ] ; then
		echo -e "[INFO] $MSG" >> /system-build-logs/build.log
	fi

	# Non-chroot, not mounted
	if [ -r '/mnt/physix/var/physix/system-build-logs/build.log' ] ; then
		echo -e "[INFO] $MSG" >> /mnt/physix/var/physix/system-build-logs/build.log
	else
		echo -e "[INFO] $MSG" >> /tmp/physix-init-host-build.log
	fi

}

function ok() {
        local MSG=$1
	local BR=''
	local TIME=`date "+%D %T"`

	if [ -r '/mnt/physix/var/physix/system-build-logs/' ] && [ -r '/mnt/physix/physix/' ] ; then
		BR=$BUILDROOT
	fi

        echo -e "\e[92m[OK]\e[0m $TIME : $MSG"
        echo -e "[OK] $TIME : $MSG" >> $BR/var/physix/system-build-logs/build.log
}


function error() {
        local MSG=$1
	local BR=''

	if [ -r '/mnt/physix/var/physix/system-build-logs/' ] && [ -r '/mnt/physix/physix/' ] ; then
		BR=$BUILDROOT
	fi

        echo -e "\e[31m[ERROR]\e[0m $TIME :$MSG"
        echo -e "[ERROR] $TIME : $MSG" >> $BR/var/physix/system-build-logs/build.log
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
			grep '\[ERROR\]' /var/physix/system-build-logs/*.sh > /var/physix/system-build-logs/err.log
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


# Returns name of the directory contained in archive.
# Assumes CWD is /sources
function stripit() {
	local NAME=$1
	STRIPPED=''
	local DN=''
	DN=$(tar -tf $NAME | cut -d'/' -f1 | head -n 1)
	if [ $? -ne 0 ] ; then
		echo "[ERROR] stripit : tar -tf $NAME"
		exit 1
	fi
	STRIPPED=$DN
}

# Returns name of the directory contained in archive.
# Assumes it is run after unpack()
function return_src_dir() {
	local ARCHIVE=$1
	local FLAG=${2:-''}
	local BR=''
	local TMP=''
	SRC_DIR='NULL'

	if [ "$FLAG" == "NCHRT" ] ; then
		BR=$BUILDROOT
	fi

	TMP=$(tar -tf $BR/sources/$ARCHIVE | cut -d'/' -f1 | head -n 1)
	if [ $? -ne 0 ] ; then
		echo "[ERROR] return_src_dir(): tar -tf $NAME"
		exit 1
	fi

	if [ -e $BR/sources/$TMP ] ; then
		export SRC_DIR=$TMP
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
	local TIME=`date "+%Y-%m-%d-%T"`

	if [ "$IO" == 'log'  ] ; then
		IO_DIRECTION="&> /var/physix/system-build-logs/$TIME-$SCRIPT"
	else
		IO_DIRECTION="| tee /var/physix/system-build-logs/$TIME-$SCRIPT"
	fi

	chroot "$BUILDROOT" /tools/bin/env -i HOME=/root  TERM="$TERM" \
		PS1='(physix chroot) \u:\w\$ '                         \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin                     \
		/bin/bash --login -c "/physix/build-scripts.config/$SCRIPT $PKG $IO_DIRECTION"
}


# Used by 2-build-base-sys.sh
# Runs build scripts under /tools/bin/bash
function chroot-build {
	local SPATH=$1
	local SCRIPT=$2
	local SRC0=${3:-''}
	local SRC1=${4:-''}
	local TIME=`date "+%Y-%m-%d-%T"`

	chroot "$BUILDROOT" /tools/bin/env -i HOME=/root  TERM="$TERM" \
		PS1='(physix chroot) \u:\w\$ '                         \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin          \
		/tools/bin/bash --login +h -c "/physix/build-scripts.base/$SCRIPT $SRC0 $SRC1 &> /var/physix/system-build-logs/$TIME-$SCRIPT"

}


# Unpacks source archives.
# Assumes chrooted env uless NCHRT Flag is passsed as arg 2
function unpack() {
	PKG=$1
	local OWNER=${2:-''}
	local FLAG=${3:-''}
	local BR=''

	if [ "$FLAG" == "NCHRT" ] ; then
		BR=$BUILDROOT
	fi

	DIR=$(tar -tf $BR/sources/$PKG | cut -d'/' -f1 | head -n 1)
        if [ -d $BR/sources/$DIR ] ; then
                rm -rf $DIR
        fi

        tar xf $BR/sources/$PKG -C $BR/sources
	if [ $? -ne 0 ] ; then
		error "tar xf $BR/sources/$PKG"
		exit 1
	fi
	if [ "$OWNER" != "" ] ; then
		chown --recursive $OWNER $BR/sources/$DIR
	fi

}


# Download sources packages
function pull_sources() {
	local LIST=$1
	local DEST_DIRECTORY=$2
        local ERROR=0

	if [ ! -d $DEST_DIRECTORY ] ; then
		mkdir -v $DEST_DIRECTORY
	fi

        echo -e "\n\nDownloading $LIST Sources..."
        for LINE in `cat $LIST | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
		local PKG_NAME=`echo $LINE | cut -d, -f1`
		local PKG_URL=`echo $LINE | cut -d, -f2`
		local PKG_MD5=`echo $LINE | cut -d, -f3`
		echo "PKG_NAME $PKG_NAME"
		echo "PKG_URL $PKG_URL"
		echo "PKG_MD5 $PKG_MD5"
                wget -q --continue --directory-prefix=$DEST_DIRECTORY $PKG_URL
                if [ $? -ne 0 ] ; then
                        echo -e "\e[31m[ ERROR ]\e[0m Downloading $PKG_URL"
                        ERROR=1
                else
                        echo -e "\e[92m[ OK ]\e[0m Downloading $PKG_URL"
                fi

		C=`md5sum $DEST_DIRECTORY/$PKG_NAME | cut -d' ' -f1`
		if [ "$PKG_MD5" == "$C" ] ; then
		        echo -e "\e[92m[ OK ]\e[0m MD5-check $PKG_NAME : $PKG_MD5"
		else
		        echo -e "\e[31m[ ERROR ]\e[0m MD5-Check $PKG_NAME : $PKG_MD5"
			echo "[FAIL] CHECK YOUR SOURCES! At lease 1 package is not Authentic."
		        ERROR=1
		fi

        done
        return $ERROR
}


