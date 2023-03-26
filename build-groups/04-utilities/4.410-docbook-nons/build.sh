#!/bin/bash
source ../include.sh || exit 1

prep() {
	patch -Np1 -i ../docbook-xsl-nons-1.79.2-stack_fix-1.patch
	chroot_check $? "docbook: patch"
}

config() {
	return 0
}

build() {
	return 0
}

build_install() {
	install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2 &&
	cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
        	 highlighting html htmlhelp images javahelp lib manpages params  \
         	profiling roundtrip slides template tests tools webhelp website \
         	xhtml xhtml-1_1 xhtml5                                          \
    	/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2 &&

	ln -sfv VERSION /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2/VERSION.xsl &&

	install -v -m644 -D README \
        	            /usr/share/doc/docbook-xsl-nons-1.79.2/README.txt &&
	install -v -m644    RELEASE-NOTES* NEWS* \
        	            /usr/share/doc/docbook-xsl-nons-1.79.2
	chroot_check $? "docbook: install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

