#!/bin/bash -x
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

patch -Np1 -i ../../mesa-19.1.4-add_xdemos-1.patch
#chroot_check $? "patch "

GALLIUM_DRV="i915,nouveau,r600,radeonsi,svga,swrast,virgl"
DRI_DRIVERS="i965,nouveau"

[ ! -e ./build ] || rm -r ./build

mkdir build &&
cd    build 

meson --prefix=$XORG_PREFIX          \
      -Dbuildtype=release            \
      -Ddri-drivers=$DRI_DRIVERS     \
      -Dgallium-drivers=$GALLIUM_DRV \
      -Dgallium-nine=false           \
      -Dglx=dri                      \
      -Dosmesa=gallium               \
      -Dvalgrind=false               \
      ..                             &&
unset GALLIUM_DRV DRI_DRIVERS &&
ninja
chroot_check $? ""

ninja install

install -v -dm755 /usr/share/doc/mesa-19.1.4 &&
cp -rfv ../docs/* /usr/share/doc/mesa-19.1.4
chroot_check $? ""

