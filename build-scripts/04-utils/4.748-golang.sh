#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep(){
	return 0
}

config() {
	return 0
}

build() {
        CGO_ENABLED=0 && cd ./src && ./make.bash
        chroot_check $? "bootstrap"

        [ ! -e /home/physix/go1.4 ] || rm -r /home/physix/go1.4
        cp -r ../../go /home/physix/go1.4
        chroot_check $? "mv bootstrap to /home/physix/go1.4"

        cd ../../go-go1.14.4/src/
        GOROOT_BOOTSTRAP=/home/physix/go1.4/bin ; ./make.bash
        chroot_check $? "make.bash"
}

build_install() {
	cd ../go-go1.14.4/src/
	rm -r /usr/bin/go
	rm -r /usr/bin/golang
	rm -r /home/physix/go1.4
	mv /opt/admin/sources.physix/BUILDBOX/go-go1.14.4 /usr/bin/golang  &&  
	ln -s /usr/bin/golang/bin/go /usr/bin/go
	chroot_check $? "install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

