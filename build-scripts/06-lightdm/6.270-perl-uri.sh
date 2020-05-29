#!/bin/bash
source /opt/physix/include.sh || exit 1


su physix -c 'perl Makefile.PL' 
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

#su physix -c 'make test'
#chroot_check $? "make test" 

make install
chroot_check $? "make install"

