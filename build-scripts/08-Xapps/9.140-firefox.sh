#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'cp /physix/build-scripts/Xapps/configs/firefox/mozconfig .'
chroot_check $? 'Write mozconfig'

su physix -c 'patch -Np1 -i ../firefox-68.0.2-system_graphite2_harfbuzz-1.patch'
chroot_check $? "patch"

su physix -c 'export PATH=$PATH:/usr/bin/rustc/bin ; export CC=gcc CXX=g++ && export MOZBUILD_STATE_PATH=${PWD}/mozbuild && ./mach build'
chroot_check $? 'configure'

./mach install && mkdir -pv  /usr/lib/mozilla/plugins &&
ln    -sfv ../../mozilla/plugins /usr/lib/firefox/browser/
chroot_check $? 'make install'

