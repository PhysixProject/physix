# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

export BUILDROOT='/mnt/physix'

function ok() {
	local MSG=$1
	echo -e "\e[92m[OK]\e[0m $MSG"
	echo "[OK] $MSG\n" >> $BUILDROOT/system-build-logs/build.log
}

function error() {
	local MSG=$1
	echo -e "\e[31m[ERROR]\e[0m $MSG"
	echo "[ERROR] $MSG\n" >> $BUILDROOT/system-build-logs/build.log
}

function chroot_ok() {
	local MSG=$1
	echo -e "\e[92m[OK]\e[0m $MSG"
	echo "[OK] $MSG\n" >> /system-build-logs/build.log
}

function chroot_error() {
	local MSG=$1
	echo -e "\e[31m[ERROR]\e[0m $MSG"
	echo "[ERROR] $MSG\n" >> /system-build-logs/build.log
}


# Check, handle and log return code
# used for scripts executed 'within' chroot'd envs
function chroot_check() {
	local RTN=$1
	local MSG=$2
	local NOEXIT=${3:-"FALSE"}
	echo "RTN:$RTN"
	if [ $RTN -ne 0 ] ; then
		chroot_error "$MSG"
		if [ $NOEXIT == "FALSE" ] ; then
			grep '\[ERROR\]' /system-build-logs/*.sh > /system-build-logs/err.log
			exit 1
		fi
	else
		chroot_ok "$MSG"
		return 0
	fi
}


# Check, handle and log return code
# used for scripts executed outside chroot'd envs
function check() {
	local RTN=$1
	local MSG=$2
	local NOEXIT=${3:-"FALSE"}
	echo "RTN:$RTN"
	if [ $RTN -ne 0 ] ; then
		error "$MSG"
		if [ $NOEXIT == "FALSE" ] ; then
			grep '\[ERROR\]' $BUILDROOT/system-build-logs/*.sh > $BUILDROOT/system-build-logs/err.log
			exit 1
		fi
	else
		ok "$MSG"
		return 0
	fi
}


# Determine name of directory contained in archive
# TOTO: change name to something more descriptive.
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
		PS1='(physix chroot) \u:\w\$ ' \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin \
		/bin/bash --login -c "$SPATH/$SCRIPT $PKG $IO_DIRECTION"
}


# Used by 2-build-base-sys.sh
# Runs build scripts under /tools/bin/bash
function chroot-build {
	local SPATH=$1
	local SCRIPT=$2
	local PKG0=${3:-''}
	local PKG1=${4:-''}

	chroot "$BUILDROOT" /tools/bin/env -i HOME=/root  TERM="$TERM" \
		PS1='(physix chroot) \u:\w\$ '   \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
		/tools/bin/bash --login +h -c "$SPATH/$SCRIPT $PKG0 $PKG1 &> /system-build-logs/$SCRIPT"
}


# extract archived source code.
# This could be probably be more simple.
function chrooted-unpack() {                                                             

        PKG=$1
	cd /sources	

	echo $PKG | grep 'tar.gz'
	if [ $? -eq 0 ]  ; then  
	        DIR=`echo $PKG | sed s/.tar.gz//`                                      
        	if [ -d /sources/$DIR ] ; then                                          
                	rm -rvf $DIR                                                     
        	fi
	fi


        echo $PKG | grep 'tar.bz2'                                               
        if [ $? -eq 0 ]  ; then
		DIR=`echo $PKG | sed s/.tar.bz2//`
        	if [ -d /sources/$DIR ] ; then
                	rm -rvf $DIR
        	fi
	fi

        echo $PKG | grep 'tar.xz'                                              
        if [ $? -eq 0 ]  ; then
        	DIR=`echo $PKG | sed s/.tar.xz//`
        	if [ -d /sources/$DIR ] ; then
                	rm -rvf $DIR
        	fi
	fi
 
        tar xf $PKG -C /sources
        check $? "tar xf $PKG"
}

#THIS CAN BE SIMPLIFIED
function unpack() {
	
	PKG=$1
	cd $BUILDROOT/sources

        echo $PKG | grep 'tar.gz'                                               
        if [ $? -eq 0 ]  ; then                                                 
                DIR=`echo $PKG | sed s/.tar.gz//`                               
                if [ -d $BUILDROOT/sources/$DIR ] ; then                                  
                        rm -rvf $DIR                                            
                fi                                                              
        fi                                                                      
                                                                                
                                                                                
        echo $PKG | grep 'tar.bz2'                                              
        if [ $? -eq 0 ]  ; then                                                 
                DIR=`echo $PKG | sed s/.tar.bz2//`                              
                if [ -d $BUILDROOT/sources/$DIR ] ; then                                  
                        rm -rvf $DIR                                            
                fi                                                              
        fi                                                                      
                                                                                
        echo $PKG | grep 'tar.xz'                                               
        if [ $? -eq 0 ]  ; then                                                 
                DIR=`echo $PKG | sed s/.tar.xz//`                               
                if [ -d $BUILDROOT/sources/$DIR ] ; then                                  
                        rm -rvf $DIR                                            
                fi                                                              
        fi

	tar xf $PKG -C $BUILDROOT/sources
	check $? "tar xf $PKG"
}


