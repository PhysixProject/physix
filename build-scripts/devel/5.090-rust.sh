#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'ping -q -c 3  8.8.8.8'
chroot_check $? "Ping: Internet Reachable"
# If this fails, try: 'ip route add default via <your-router-ip-addr>'

mkdir /opt/rustc-1.35.0  &&
ln -svfin rustc-1.35.0 /opt/rustc
chroot_check $? "mkdir /opt/rustc-*"


su physix -c 'cp /physix/build-scripts/devel/configs/rustc/config.toml .'
chroot_check $? "Set ./config.toml"


su physix -c 'export RUSTFLAGS="$RUSTFLAGS -C link-args=-lffi" &&
              python3 ./x.py build --exclude src/tools/miri'
chroot_check $? "Compile Rust"


su physix -c 'export LIBSSH2_SYS_USE_PKG_CONFIG=1 &&
              DESTDIR=${PWD}/install python3 ./x.py install &&
              unset LIBSSH2_SYS_USE_PKG_CONFIG'
chroot_check $? "DESTDIR install"


chown -Rv root:root ./install
chroot_check $? "chown ./install"

cp -a install/* /
chroot_check $? "cp install/*"

cp /physix/build-scripts/devel/configs/rustc/ld.so.conf /etc/ld.so.conf
chroot_check $? "Set /etc/ld.so.conf"
ldconfig

cp /physix/build-scripts/devel/configs/rustc/rustc.sh /etc/profile.d/rustc.sh
chroot_check $? "Set /etc/profile.d/rustc.sh"

source /etc/profile.d/rustc.sh

