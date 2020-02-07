#!/bin/bash

TAG='binutils'
DATE=`date "+%HH-%MM-%SSec-"`

for F in `find /var` ; do 
	if [ ! -d $F ] ; then
		md5sum $F >> var-$DATE 
	fi
done

for F in `find /usr` ; do
	if [ ! -d $F ] ; then
        	md5sum $F >> usr-$DATE
	fi
done


for F in `find /sbin` ; do
        if [ ! -d $F ] ; then
                md5sum $F >> sbin-$DATE
        fi
done


for F in `find /bin` ; do
        if [ ! -d $F ] ; then
                md5sum $F >> sbin-$DATE
        fi
done



