#!/bin/bash              
                         
source /physix/include.sh
                         
pull_sources /physix/src-list.utils /sources
verify_md5list "/sources" /physix/md5sum-list.utils

