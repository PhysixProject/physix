#!/bin/bash

mkdir ./$1
cd ./$1

cat << EOF >> build.sh
#!/bin/bash
source ../include.sh || exit 1

prep() {
}

config() {
}

build() {
}

build_install() {
}

[ \$1 == 'prep' ]   && prep   && exit $?
[ \$1 == 'config' ] && config && exit $?
[ \$1 == 'build' ]  && build  && exit $?
[ \$1 == 'build_install' ] && build_install && exit $?

EOF


