#!/bin/bash
source /physix/include.sh

rm -rf /usr/src/physix/sources/xc
mkdir -p /usr/src/physix/sources/xc && cd /usr/src/physix/sources/xc

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

mkdir -p /etc/profile.d/
cat > /etc/profile.d/xorg.sh << EOF
XORG_PREFIX="$XORG_PREFIX"
XORG_CONFIG="--prefix=\$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
export XORG_PREFIX XORG_CONFIG
EOF
chmod 644 /etc/profile.d/xorg.sh


