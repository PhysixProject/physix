#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1
sed -i '5481,5485 s/({/(\\{/' tp/Texinfo/Parser.pm

./configure --prefix=/usr --disable-static
chroot_check $? "texinfo"

make
chroot_check $? "texinfo make"

if [ "$CONF_RUN_ALL_TEST_SUITE"=="y" ] ; then
	make check
	chroot_check $? "texinfo make check" NOEXIT
fi

make install
chroot_check $? "texinfo make install"

make TEXMF=/usr/share/texmf install-tex
chroot_check $? "texinfo install texmf "

pushd /usr/share/info
rm -v dir
for f in *
  do install-info $f dir 2>/dev/null
done
popd

