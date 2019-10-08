#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../include.sh               
source ~/.bashrc

cd $BUILDROOT/sources      
PKG=$1
unpack $PKG
stripit $PKG
SRCD=$STRIPPED

PKG1=$2
unpack $PKG1
stripit $PKG1
SRCD1=$STRIPPED

PKG2=$3
unpack $PKG2
stripit $PKG2
SRCD2=$STRIPPED

PKG3=$4
unpack $PKG3
stripit $PKG3
SRCD3=$STRIPPED

cd $BUILDROOT/sources/$SRCD

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

mv -v ../$SRCD1 ./mpfr
mv -v ../$SRCD2 ./gmp
mv -v ../$SRCD3 ./mpc
#tar -xf ../mpfr-4.0.2.tar.xz
#mv -v mpfr-4.0.2 mpfr
#tar -xf ../gmp-6.1.2.tar.xz
#mv -v gmp-6.1.2 gmp
#tar -xf ../mpc-1.1.0.tar.gz
#mv -v mpc-1.1.0 mpc

mkdir -v build
cd       build

CC=$BUILDROOT_TGT-gcc                                    \
CXX=$BUILDROOT_TGT-g++                                   \
AR=$BUILDROOT_TGT-ar                                     \
RANLIB=$BUILDROOT_TGT-ranlib                             \
../configure                                       \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp

check $? "GCC P2: Configure"

make -j8
check $? "GCC P2: make"

make install
check $? "GCC P2 make install"

ln -sv gcc /tools/bin/cc
check $? "gcc P2: ln -sv gcc /tools/bin/cc"

rm -rf $BUILDROOT/sources/$SRCD
check $? "gcc P2: rm -rf $BUILDROOT/sources/gcc-8.2.0"


