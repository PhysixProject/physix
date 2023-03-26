#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc

prep() {

	MPFR=`find ../ -maxdepth 1 -type d  | grep mpfr`
	mv -v $MPFR mpfr
	check $? "pull in mpfr"

	GMP=`find ../ -maxdepth 1 -type d  | grep gmp`
	mv -v $GMP gmp
	check $? "pull in gmp"

	MPC=`find ../ -maxdepth 1 -type d  | grep mpc`
	mv -v $MPC mpc
	check $? "pull in  mpc"

	for file in gcc/config/{linux,i386/linux{,64}}.h
	do
	  cp -uv $file{,.orig}
  	  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
        -e 's@/usr@/tools@g' $file.orig > $file
  		echo '
		#undef STANDARD_STARTFILE_PREFIX_1
		#undef STANDARD_STARTFILE_PREFIX_2
		#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
		#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
	  	touch $file.orig
	done

	case $(uname -m) in
	  x86_64)
	  	sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
	  	;;
	esac

	mkdir -v build
}


config() {
	cd build

	../configure                                       \
	    --target=$BUILDROOT_TGT                        \
	    --prefix=/tools                                \
	    --with-glibc-version=2.11                      \
	    --with-sysroot=$BUILDROOT                      \
	    --with-newlib                                  \
	    --without-headers                              \
	    --with-local-prefix=/tools                     \
	    --with-native-system-header-dir=/tools/include \
	    --disable-nls                                  \
	    --disable-shared                               \
	    --disable-multilib                             \
	    --disable-decimal-float                        \
	    --disable-threads                              \
	    --disable-libatomic                            \
	    --disable-libgomp                              \
	    --disable-libquadmath                          \
	    --disable-libssp                               \
	    --disable-libvtv                               \
	    --disable-libstdcxx                            \
	    --enable-languages=c,c++
		check $? "GCC Pass 1 Configure"
}


build() {
	cd build
	make -j$NPROC
	check $? "GCC Pass 1 make"
}

build_install() {
	cd build
	make install
	check $? "GCC Pass 1 make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

