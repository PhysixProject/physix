#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

su physix -c "CGO_ENABLED=0 && cd ./src && ./make.bash"
chroot_check $? "bootstrap"

[ ! -e /home/physix/go1.4 ] || rm -r /home/physix/go1.4
su physix -c "mv ../go /home/physix/go1.4"
chroot_check $? "mv bootstrap to /home/physix/go1.4"

cd ../go-go1.14.4/src/
su physix -c  "GOROOT_BOOTSTRAP=/home/physix/go1.4/bin ; ./make.bash"
chroot_check $? "make.bash"

rm -r /usr/bin/go
rm -r /usr/bin/golang
rm -r /home/physix/go1.4
mv /opt/admin/sources.physix/BUILDBOX/go-go1.14.4 /usr/bin/golang  &&  
ln -s /usr/bin/golang/bin/go /usr/bin/go
chroot_check $? "install"

