#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

# Uncomment these 2 cp commands to build generic libraries.
#cp -v configfsf.guess config.guess
#cp -v configfsf.sub   config.sub

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2
chroot_check $? "system-build : GMP : configure"

make -j8
chroot_check $? "system-build : GMP : make "

make html
chroot_check $? "system-build : GMP : make html"

#critical
make check 2>&1 | tee gmp-check-log
chroot_check $? "system-build : GMP : make check"

awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
chroot_check $? "system-build : GMP : awk"
#TODO verify 190

make install
chroot_check $? "system-build : GMP : make install"

make install-html
chroot_check $? "system-build : GMP : make install html"

