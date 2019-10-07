#!/bin/bash                                                                    
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
                                                                                
source /mnt/lfs/physix/include.sh                                                               
source ~/.bashrc

cd /mnt/lfs/sources      
PKG=$1                   
stripit $PKG             
SRCD=$STRIPPED           
                         
unpack $PKG              
cd /mnt/lfs/sources/$SRCD

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
check $? "Findutiles: sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c"

sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
check $? "Findutiles: sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c"

echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h
check $? "Findutils: echo #define _IO_IN_BACKUP 0x100 >> gl/lib/stdio-impl.h " 

./configure --prefix=/tools
check $? "Findutils configure"
                                                                                
make
check $? "Findutils make"

make check
check $? "Findutils make check" noexit
                                                                                
make install
check $? "Findutils make install"

rm -rfv /mnt/lfs/sources/$SRCD

