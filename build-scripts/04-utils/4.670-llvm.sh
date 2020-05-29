#!/bin/bash
source /opt/physix/include.sh || exit 1

su physix -c 'cp -r ../compiler-rt-8.0.1.src ./projects'
chroot_check $? "cp -r ../compiler-rt-8.0.1.src ./projects"

su physix -c 'cp -r ../cfe-8.0.1.src ./tools'
chroot_check $? "cp -r ../cfe-8.0.1.src ./tools"

su physix -c 'mv -v ./tools/cfe-8.0.1.src tools/clang'
chroot_check $? "mv -v ./tools/cfe-8.0.1.src tools/clang"

su physix -c 'mv ./projects/compiler-rt-8.0.1.src projects/compiler-rt'
chroot_check $? "mv ./projects/compiler-rt-8.0.1.src projects/compiler-rt"

su physix -c 'mkdir -v build &&
              cd build       &&                 
CC=gcc CXX=g++               &&                  
cmake -DCMAKE_INSTALL_PREFIX=/usr               \
      -DLLVM_ENABLE_FFI=ON                      \
      -DCMAKE_BUILD_TYPE=Release                \
      -DLLVM_BUILD_LLVM_DYLIB=ON                \
      -DLLVM_LINK_LLVM_DYLIB=ON                 \
      -DLLVM_ENABLE_RTTI=ON                     \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
      -DLLVM_BUILD_TESTS=ON                     \
      -Wno-dev -G Ninja ..'
chroot_check $? "LLVM : configure"

pwd
cd build
pwd
su physix -c 'ninja'
chroot_check $? "LLVM : ninjja (make)"

#ninja docs-clang-html docs-clang-man
#chroot_check $? "LLVM : ninja docs-clang-html docs-clang-man"

ninja install
chroot_check $? "LLVM : ninjja install"

