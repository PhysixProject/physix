#!/bin/bash
source /opt/physix/include.sh || exit 1

tar -xf lsof_4.91_src.tar  &&
cd lsof_4.91_src           &&
./Configure -n linux       &&
make CFGL="-L./lib -ltirpc"
chroot_check $? "lsof : configur and make"

install -v -m0755 -o root -g root lsof /usr/bin &&
install -v lsof.8 /usr/share/man/man8
chroot_check $? "lsof : install"

