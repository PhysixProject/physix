#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


su physix -c "mkdir mozjs-build"
cd mozjs-build
su physix -c "../js/src/configure --prefix=/usr \
                    --with-intl-api     \
                    --with-system-zlib  \
                    --with-system-icu   \
                    --disable-jemalloc  \
                    --enable-readline"
chroot_check $? "configure"

su physix -c "make"
chroot_check $? "make"

make install 
chroot_check $? "make install"

