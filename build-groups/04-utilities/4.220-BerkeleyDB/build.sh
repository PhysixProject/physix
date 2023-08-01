#!/bin/bash
source ../include.sh || exit 1

prep() {
	sed -i 's/\(__atomic_compare_exchange\)/\1_db/' src/dbinc/atomic.h
}

config() {
	cd build_unix          &&
	../dist/configure --prefix=/usr      \
                  --enable-compat185 \
                  --enable-dbm       \
                  --disable-static   \
                  --enable-cxx
	chroot_check $? "BerkeleyDB : configure"
}

build() {
	cd build_unix && make -j$NPROC
	chroot_check $? "BerkeleyDB : make"
}

build_install() {
	cd build_unix
	make docdir=/usr/share/doc/db-5.3.28 install
	chroot_check $? "BerkeleyDB : make docs"

	chown -v -R root:root                  \
      	/usr/bin/db_*                          \
      	/usr/include/db{,_185,_cxx}.h          \
      	/usr/lib/libdb*.{so,la}                \
      	/usr/share/doc/db-5.3.28
	chroot_check $? "BerkeleyDB : chown of db fiels"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

