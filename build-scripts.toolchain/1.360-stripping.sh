#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../include.sh
source ~/.bashrc

# file format not recognized issue
#strip --strip-debug /tools/lib/*
check $? "strip --strip-debug /tools/lib/*"

#fails
#/usr/bin/strip --strip-unneeded /tools/{,s}bin/*
#check $? "/usr/bin/strip --strip-unneeded /tools/{,s}bin/*"

rm -rf /tools/{,share}/{info,man,doc}
check $? "rm -rf /tools/{,share}/{info,man,doc}"

find /tools/{lib,libexec} -name \*.la -delete
check $? "find /tools/{lib,libexec} -name \*.la -delete"


