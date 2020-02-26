#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

#This sed prevents it compiling 2 programs (vsyasm and ytasm) 
#that are only of use on Microsoft Windows.
su physix -c "sed -i 's#) ytasm.*#)#' Makefile.in"
chroot_check $? "Sed fix"

su physix -c './configure --prefix=/usr'
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"

