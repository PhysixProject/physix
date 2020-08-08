#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /mnt/physix/opt/admin/physix/include.sh || exit 1
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

	cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $($BUILDROOT_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

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
	    sed -e '/m64=/s/lib64/lib/' \
	        -i.orig gcc/config/i386/t-linux64
	  ;;
	esac

	sed -e '1161 s|^|//|' \
    	-i libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc
	check $? "sed: sanitizer_platform_limits_posix.cc"

	mkdir -v build
}

config() {
	cd build

	CC=$BUILDROOT_TGT-gcc                          \
	CXX=$BUILDROOT_TGT-g++                         \
	AR=$BUILDROOT_TGT-ar                           \
	RANLIB=$BUILDROOT_TGT-ranlib                   \
	../configure                                   \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp

	check $? "GCC P2: Configure"
}

build() {
	cd build
	make -j8
	check $? "GCC P2: make"
}

build_install() {
	cd build
	make install
	check $? "GCC P2 make install"

	ln -sfv gcc /tools/bin/cc
	check $? "gcc P2: ln -sfv gcc /tools/bin/cc"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

