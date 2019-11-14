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


function ok() {
        local MSG=$1
	local BR=''

	if [ -r '/mnt/physix/system-build-logs/' ] && [ -r '/mnt/physix/physix/' ] ; then
		BR=$BUILDROOT
	fi

        echo -e "\e[92m[OK]\e[0m $MSG"
        echo "[OK] $MSG\n" >> $BR/system-build-logs/build.log
}


function error() {
        local MSG=$1
	local BR=''

	if [ -r '/mnt/physix/system-build-logs/' ] && [ -r '/mnt/physix/physix/' ] ; then
		BR=$BUILDROOT
	fi

        echo -e "\e[31m[ERROR]\e[0m $MSG"
        echo "[ERROR] $MSG\n" >> $BR/system-build-logs/build.log
}

# Check, handle and log return code
# used for scripts executed 'within' chroot'd envs
function chroot_check() {
	local RTN=$1
	local MSG=$2
	local NOEXIT=${3:-"FALSE"}
	echo "RTN:$RTN"
	if [ $RTN -ne 0 ] ; then
		error "$MSG"
		if [ $NOEXIT == "FALSE" ] ; then
			grep '\[ERROR\]' /system-build-logs/*.sh > /system-build-logs/err.log
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
	echo "RTN:$RTN"
	if [ $RTN -ne 0 ] ; then
		error "$MSG"
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


# Used by 3-config-base-sys.sh and beyond
# Runs build scripts under /bin/bash
function chroot-conf-build {
	local SPATH=$1
	local SCRIPT=$2
	local PKG=${3:-''}
	local IO=${4:-''}
	local IO_DIRECTION=''

	if [ "$IO" == 'log'  ] ; then
		IO_DIRECTION="&> /system-build-logs/$SCRIPT"
	else
		IO_DIRECTION="| tee /system-build-logs/$SCRIPT"
	fi

	chroot "$BUILDROOT" /tools/bin/env -i HOME=/root  TERM="$TERM" \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin \
		/bin/bash --login -c "$SPATH/$SCRIPT $PKG $IO_DIRECTION"
}


# Used by 2-build-base-sys.sh
# Runs build scripts under /tools/bin/bash
function chroot-build {
	local SPATH=$1
	local SCRIPT=$2
	local PKG0=${3:-''}
	local PKG1=${3:-''}

	chroot "$BUILDROOT" /tools/bin/env -i HOME=/root  TERM="$TERM" \
		PS1='(lfs chroot) \u:\w\$ '   \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
		/tools/bin/bash --login +h -c "$SPATH/$SCRIPT $PKG0 $PKG1 &> /system-build-logs/$SCRIPT"
}


# Unpacks source archives. 
# Assumes chrooted env uless NCHRT Flag is passsed as arg 2
function unpack() {
	PKG=$1
	FLAG=${2:-''}
	local BR=''

	if [ "$FLAG" == "NCHRT" ] ; then
		BR=$BUILDROOT
	fi
        cd $BR/sources

        stripit $PKG
        DIR=$STRIPPED

        if [ -d $BR/sources/$DIR ] ; then
                rm -rvf $DIR
        fi

        tar xf $PKG -C $BR/sources
        check $? "tar xf $PKG"
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


