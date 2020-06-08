#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c "make"
chroot_check $? "traceroute : make"

make prefix=/usr install                                 &&
mv /usr/bin/traceroute /bin                              &&
ln -sv -f traceroute /bin/traceroute6                    &&
ln -sv -f traceroute.8 /usr/share/man/man8/traceroute6.8 &&
rm -fv /usr/share/man/man1/traceroute.1
chroot_check $? "traceroute : make install"

