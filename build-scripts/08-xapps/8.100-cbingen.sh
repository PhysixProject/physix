#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/rustc.sh
cd $SOURCE_DIR/$1 || exit 1
echo $PATH

# FIXME: Running as physix user hits permissions issue.
#su physix -c '/usr/bin/rustc/bin/cargo build --release'
/usr/bin/rustc/bin/cargo build --release
chroot_check $? "cargo build"

install -Dm755 target/release/cbindgen /usr/bin/
chroot_check $? "make install"

