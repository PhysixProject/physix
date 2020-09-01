#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

rm -f /usr/lib/gcc

mkdir -v build
cd       build


SED=sed                               \
../configure --prefix=/usr            \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-libmpx         \
             --with-system-zlib
chroot_check $? "system-build : gcc : configure"

make -j8
chroot_check $? "system-build : gcc : make "


if [ "$CONF_RUN_ALL_TEST_SUITE"=="y" ] ; then
	ulimit -s 32768
	make -k check

	#rm ../gcc/testsuite/g++.dg/pr83239.C
	#chown -Rv nobody .
	#su nobody -s /bin/bash -c "PATH=$PATH make -k check"

	../contrib/test_summary
fi

make install
chroot_check $? "system-build : gcc  : make install"

ln -sv ../usr/bin/cpp /lib &&
ln -sv gcc /usr/bin/cc
chroot_check $? "ln cpp and cc"

install -v -dm755 /usr/lib/bfd-plugins &&
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/8.2.0/liblto_plugin.so  /usr/lib/bfd-plugins
chroot_check $? "install and link plugin"

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log && readelf -l a.out | grep ': /lib'
chroot_check $? "cc dummy.c: Compiler looks broken"

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
grep -B4 '^ /usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log

rm -v dummy.c a.out dummy.log
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

