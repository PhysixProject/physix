# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

export BUILDROOT='/mnt/physix'

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


#function chrooted-unpack() {
#        PKG=$1
#	cd /sources
#
#	strippit $PKG 
#	DIR=$STRIPPED
#
#	if [ -d /sources/$DIR ] ; then
#		rm -rvf $DIR
#	fi
# 
#        tar xf $PKG -C /sources
#        check $? "tar xf $PKG"
#}


#function unpack() {
#	PKG=$1
#	cd $BUILDROOT/sources
#
#	strippit $PKG
#	DIR=$STRIPPED
#
#	if [ -d $BUILDROOT/sources/$DIR ] ; then
#		rm -rvf $DIR
#	fi
#
#	tar xf $PKG -C $BUILDROOT/sources
#	check $? "tar xf $PKG"
#}

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
        for pkg in `cat $LIST | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
                wget -q --continue --directory-prefix=$DEST_DIRECTORY $pkg
                if [ $? -ne 0 ] ; then
                        echo -e "\e[31m[ ERROR ]\e[0m $pkg"
                        ERROR=1
                else
                        echo -e "\e[92m[ OK ]\e[0m $pkg"
                fi
        done
        return $ERROR
}

# Fetch the expected md5sum of a source package.
function md5_lookup() {
        local FILE_NAME=$1
	local LIST=$2
        local MD5SUM=''
        RTN=''
        for ENTRY in `cat ./$LIST | grep -v -e '^#' | grep -v -e '^\s*$'` ; do
                ENTRY_NAME=`echo $ENTRY | cut -d ',' -f1`
                MD5SUM=`echo $ENTRY | cut -d ',' -f2`
                if [ "$ENTRY_NAME" == "$FILE_NAME" ] ; then
                        RTN=$MD5SUM
                        return
                fi
        done
}

function verify_md5list() {
        local SOURCES_DIR=$1
        local LIST=$2
        local ERR=0
	local ENTRY=''

        echo -e "\n\nVerify Sources md5sums..." 
        for ENTRY in `cat $LIST | grep -v -e '^#' | grep -v -e '^\s*$'` ; do

		FILE_NAME=`echo $ENTRY | cut -d ',' -f1`
		MD5=`echo $ENTRY | cut -d ',' -f2`

                C=`md5sum $SOURCES_DIR/$FILE_NAME | cut -d' ' -f1`
                if [ "$MD5" == "$C" ] ; then
                        echo -ne "\e[92m[ OK ]\e[0m "
                else
                        echo -ne "\e[31m[ ERROR ]\e[0m "
                        ERR=1
                fi
                echo  "$FILE_NAME: $C"
        done

        if [ $ERR -ne 0  ] ; then
                echo "[FAIL] CHECK YOUR SOURCES! At lease 1 package is not Authentic."
                exit 1
        fi
}


