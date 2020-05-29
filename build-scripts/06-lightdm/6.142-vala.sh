#!/bin/bash
source /opt/physix/include.sh || exit 1
PATH=$PATH:/opt/rustc/bin/


su physix -c './configure --prefix=/usr'
chroot_check $? 'configure'

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install
chroot_check $? 'make install'

