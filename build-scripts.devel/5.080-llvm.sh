#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

tar -xf ../cfe-8.0.1.src.tar.xz -C tools 
chroot_check $? "LLVM : tar -xf ../cfe-8.0.1.src.tar.xz -C tools"
tar -xf ../compiler-rt-8.0.1.src.tar.xz -C projects 
chroot_check $? "LLVM : tar -xf ../cfe-8.0.1.src.tar.xz -C tools"

mv tools/cfe-8.0.1.src tools/clang 
chroot_check $? "LLVM : mv tools/cfe-8.0.1.src tools/clang "

mv projects/compiler-rt-8.0.1.src projects/compiler-rt
chroot_check $? "LLVM : mv projects/compiler-rt-8.0.1.src projects/compiler-rt"

mkdir -v build &&
cd       build &&
CC=gcc CXX=g++                                  \
cmake -DCMAKE_INSTALL_PREFIX=/usr               \
      -DLLVM_ENABLE_FFI=ON                      \
      -DCMAKE_BUILD_TYPE=Release                \
      -DLLVM_BUILD_LLVM_DYLIB=ON                \
      -DLLVM_LINK_LLVM_DYLIB=ON                 \
      -DLLVM_ENABLE_RTTI=ON                     \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
      -DLLVM_BUILD_TESTS=ON                     \
      -Wno-dev -G Ninja ..                      
chroot_check $? "LLVM : configure"

ninja
chroot_check $? "LLVM : ninjja (make)"

#ninja docs-clang-html docs-clang-man
#chroot_check $? "LLVM : ninja docs-clang-html docs-clang-man"

ninja install

rm -rf /sources/$SRCD

