#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1



./configure --prefix=/usr  \
            --bindir=/bin  \
            --libdir=/lib  \
            --disable-zstd \
            --disable-documentation
chroot_check $? "btrfs-progs : configure"

make
chroot_check $? "btrfs-progs : make"

make fssum &&
sed -i '/found/s/^/: #/' tests/convert-tests.sh &&
mv tests/convert-tests/010-reiserfs-basic/test.sh{,.broken}                 &&
mv tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh{,.broken}   &&
mv tests/convert-tests/012-reiserfs-large-hole-extent/test.sh{,.broken}     &&
mv tests/convert-tests/013-reiserfs-common-inode-flags/test.sh{,.broken}    &&
mv tests/convert-tests/014-reiserfs-tail-handling/test.sh{,.broken}         &&
mv tests/misc-tests/025-zstd-compression/test.sh{,.broken}
chroot_check $? "btrfs-progs : make tests"

pushd tests
   ./fsck-tests.sh
   ./mkfs-tests.sh
   ./cli-tests.sh
   ./convert-tests.sh
   ./misc-tests.sh
   ./fuzz-tests.sh
popd
chroot_check $? "btrfs-progs : test suite"


make install &&
ln -sfv ../../lib/$(readlink /lib/libbtrfs.so) /usr/lib/libbtrfs.so &&
ln -sfv ../../lib/$(readlink /lib/libbtrfsutil.so) /usr/lib/libbtrfsutil.so &&
rm -fv /lib/libbtrfs.{a,so} /lib/libbtrfsutil.{a,so} &&
mv -v /bin/{mkfs,fsck}.btrfs /sbin
chroot_check $? "btrfs-progs : make install"

