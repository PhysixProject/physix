#!/bin/bash
source /opt/admin/physix/include.sh

#rm -rf /usr/src/physix/sources
#mkdir -p /usr/src/physix/sources && cd /usr/src/physix/sources/xc
#chown physix:root /usr/src/physix/sources


prep() {
	return 0
}

config() {
	return 0
}

build() {
	return 0
}


build_install() {
	export XORG_PREFIX="/usr"
	export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
	    --localstatedir=/var --disable-static"

	mkdir -p /etc/profile.d/
cat > /etc/profile.d/xorg.sh << EOF
XORG_PREFIX="$XORG_PREFIX"
XORG_CONFIG="--prefix=\$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
export XORG_PREFIX XORG_CONFIG
EOF
	chmod 644 /etc/profile.d/xorg.sh
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

