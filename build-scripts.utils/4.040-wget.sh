#!/bin/bash              
                         
source /physix/include.sh
                         
cd /sources              
PKG=$1                   
stripit $PKG             
SRCD=$STRIPPED           
                         
cd /sources              
unpack $PKG     
cd /sources/$SRCD        

./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl 

chroot_check $? "wget configure"

make
chroot_check $? "wget make"

make install
chroot_check $? "wget make install"

rm -rf /sources/$SRCD
