#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1

mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
chroot_check $? "6.05-directories mkdir -pv /{bin,boot,etc/{opt,sysconfig}"

mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
chroot_check $? "6.05-directories  mkdir -pv /{media/{floppy,cdrom}"

install -dv -m 0750 /root                                      &&
install -dv -m 1777 /tmp /var/tmp                              &&
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}             &&
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man} &&
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}         &&
mkdir -pv /usr/libexec                                         &&
mkdir -pv /usr/{,local/}share/man/man{1..8}                    
chroot_check $? "setup /usr"

case $(uname -m) in
 x86_64) mkdir -v /lib64 ;;
esac

mkdir -vp /var/{log,mail,spool}  &&
ln -svf /run /var/run            &&
ln -svf /run/lock /var/lock      &&
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}
chroot_check $? "setup /run/lock"


#6.6
ln -svf /tools/bin/{bash,cat,chmod,dd,echo,ln,mkdir,pwd,rm,stty,touch} /bin &&
ln -svf /tools/bin/{env,install,perl,printf}         /usr/bin               &&
ln -svf /tools/lib/libgcc_s.so{,.1}                  /usr/lib               &&
ln -svf /tools/lib/libstdc++.{a,so{,.6}}             /usr/lib
chroot_check $? "link /tools/lib  /usr/lib"


install -vdm755 /usr/lib/pkgconfig &&
ln -svf bash /bin/sh                &&
ln -svf /proc/self/mounts /etc/mtab
chroot_check $? "link bash/sh"

cp /opt/admin/physix/build-groups/02-base/2.010-directories/etc_passwd /etc/passwd
chroot_check $? "Wrote /etc/passwd"

cp /opt/admin/physix/build-groups/02-base/2.010-directories/etc_group /etc/group
chroot_check $? "wrote /etc/group"

touch /var/log/{btmp,lastlog,faillog,wtmp} &&
chgrp -v utmp /var/log/lastlog             &&
chmod -v 664  /var/log/lastlog             &&
chmod -v 600  /var/log/btmp                
chroot_check $? "wrote /var/log/{group,lastlog,btmp}"

