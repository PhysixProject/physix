#!/bin/bash
source ../include.sh || exit 1
source /etc/physix.conf || exit 1

prep() {
	ping -q -c 3  8.8.8.8
	chroot_check $? "Ping: Internet Reachable"
	# If this fails, try: 'ip route add default via <your-router-ip-addr>'

	#if [ -e /usr/bin/rustc ] ; then
        #	rm /usr/bin/rustc
	#fi

	#if [ -e /usr/bin/rustc-1.35.0 ] ; then
	#	rm -r /usr/bin/rustc-1.35.0
	#fi

	#mkdir /usr/bin/rustc-1.35.0  &&
	#ln -svfin /usr/bin/rustc-1.35.0 /usr/bin/rustc
	#chroot_check $? "mkdir /opt/admin/rustc-*"

        mkdir -p ../transroot/rustc-1.35.0 && ln -svfin ../transroot/rustc-1.35.0 ../transroot/rustc
        chroot_check $? "mkdir ../transroot/rustc-1.35.0"
}


config() {
	cp /opt/admin/physix/build-scripts/04-utils/configs/rustc/config.toml .
	chroot_check $? "Set ./config.toml"
}


build() {
        export RUSTFLAGS="$RUSTFLAGS -C link-args=-lffi" &&
           python3 ./x.py build --exclude src/tools/miri
        chroot_check $? "Compile Rust"

        export LIBSSH2_SYS_USE_PKG_CONFIG=1 &&
                RUST_BACKTRACE=1 &&
                DESTDIR=${PWD}/install python3 ./x.py install &&
                unset LIBSSH2_SYS_USE_PKG_CONFIG
        chroot_check $? "DESTDIR install"
}


build_install() {
	chown -Rv root:root ./install
	chroot_check $? "chown ./install"

	cp -av install/* /
	chroot_check $? "cp install/*"

	install -v -m644 $PKG_DIR_PATH/ld.so.conf /etc/ld.so.conf
	chroot_check $? "Set /etc/ld.so.conf"

	install -v -m644 $PKG_DIR_PATH/rustc.sh /etc/profile.d/rustc.sh
	chroot_check $? "Set /etc/profile.d/rustc.sh"

        mv ./../transroot/bin    ./../transroot/rustc-1.35.0  &&
        mv ./../transroot/lib/   ./../transroot/rustc-1.35.0  &&
        mv ./../transroot/share  ./../transroot/rustc-1.35.0
	chroot_check $? "Move live,bin,share to rustc-1.35.0"

        mv ./../transroot/rustc-1.35.0 /usr/bin/ &&
        ln -s /usr/bin/rustc-1.35.0  /usr/bin/rustc
	chroot_check $? "mv rust to /usr/bin and link it"

        source /etc/profile.d/rustc.sh && ldconfig
	chroot_check $? "ldconfig"
        rm -rf /home/physix/.cargo
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

