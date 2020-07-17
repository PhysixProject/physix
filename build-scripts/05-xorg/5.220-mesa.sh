#!/bin/bash -x
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	patch -Np1 -i ../../mesa-19.1.4-add_xdemos-1.patch
	chroot_uheck $? "patch "
	mkdir build
}

config() {
	GALLIUM_DRV="i915,nouveau,r600,radeonsi,svga,swrast,virgl"
	DRI_DRIVERS="i965,nouveau"

	cd    build 
	meson --prefix=$XORG_PREFIX    \
      	-Dbuildtype=release            \
      	-Ddri-drivers=$DRI_DRIVERS     \
      	-Dgallium-drivers=$GALLIUM_DRV \
      	-Dgallium-nine=false           \
      	-Dglx=dri                      \
      	-Dosmesa=gallium               \
      	-Dvalgrind=false               \
      	..                             &&
	unset GALLIUM_DRV DRI_DRIVERS 
}

build() {
	cd build
	ninja
	chroot_check $? "ninja"
}

build_install() {
	cd build
	ninja install

	install -v -dm755 /usr/share/doc/mesa-19.1.4 &&
	cp -rfv ../docs/* /usr/share/doc/mesa-19.1.4
	chroot_check $? ""
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?




