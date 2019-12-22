#!/bin/bash              
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
                         
pull_sources /physix/src-list.utils /sources
verify_md5list "/sources" /physix/md5sum-list.utils

