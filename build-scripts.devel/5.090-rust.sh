#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

export RUSTFLAGS="$RUSTFLAGS -C link-args=-lffi" &&
python3 ./x.py build --exclude src/tools/miri
chroot_check $? "python3 ./x.py build --exclude src/tools/miri"

chown -R root:root install &&
cp -a install/* /

cat << EOF > config.toml
# see config.toml.example for more possible options
# See the 8.4 book for an example using shipped LLVM
# e.g. if not installing clang, or using a version before 8.0.
[llvm]
# by default, rust will build for a myriad of architectures
targets = "X86"

# When using system llvm prefer shared libraries
link-shared = true

[build]
# omit docs to save time and space (default is to build them)
docs = false

# install cargo as well as rust
extended = true

[install]
prefix = "/opt/rustc-1.35.0"
docdir = "share/doc/rustc-1.35.0"

[rust]
channel = "stable"
rpath = false

# BLFS does not install the FileCheck executable from llvm,
# so disable codegen tests
codegen-tests = false

[target.x86_64-unknown-linux-gnu]
# NB the output of llvm-config (i.e. help options) may be
# dumped to the screen when config.toml is parsed.
llvm-config = "/usr/bin/llvm-config"

[target.i686-unknown-linux-gnu]
# NB the output of llvm-config (i.e. help options) may be
# dumped to the screen when config.toml is parsed.
llvm-config = "/usr/bin/llvm-config"

EOF


export RUSTFLAGS="$RUSTFLAGS -C link-args=-lffi" &&
python3 ./x.py build --exclude src/tools/miri




