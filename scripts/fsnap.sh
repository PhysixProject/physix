#!/bin/bash 

function snapshot {
	local DIR=$1
	local TAG=$2
	local SNAP="$TAG"-$DATE

	for F in $(find $1) ; do
        	if [ ! -d $F ] ; then
                	md5sum $F >> $SNAP
        	else
                	echo "Directory  $F" >> $SNAP
        	fi
	done
}


DATE=`date "+%HH-%MM-%SSec"`

TAG=$1
snapshot '/etc' $TAG
snapshot '/usr' $TAG
snapshot '/bin' $TAG
snapshot '/sbin' $TAG

