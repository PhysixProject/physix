#!/usr/bin/python
import os
import subprocess
import hashlib
import shutil
import sys
import pwd

BUILDROOT = "/mnt/physix"



#---------------------------------------------
#---------------------------------------------
def verify_checker():
    #for tool in ['mkfs.ext3', 'gcc', 'g++', 'make', 'gawk', 'bison'] :
    #
    devlst = os.listdir("/dev")
    for dev in devlst :
        print (dev)


#---------------------------------------------
#---------------------------------------------
def load_config():
    config = {}
    with open('./build.conf',"r") as FD:
        lines = FD.readlines()
        for line in lines:
            if not line.startswith('#'):
                lst = line.split("=")
                if len(lst) == 2 :
                    config[lst[0]] = lst[1]
    return config


#---------------------------------------------
#---------------------------------------------
def run_cmd(cmd):
    print("Running: " + str(cmd))
    try:
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = p.communicate()
        if err:
            print(err)
    except:
        print ("[ERROR] Opperation Failed:"),
        print (cmd)
        sys.exit(1)


#---------------------------------------------
#---------------------------------------------
def create_partitions(config):

    root_device = "/dev/" + config["CONF_ROOT_DEVICE"]
    root_device = root_device.strip("\n")

    # UEFI 1
    uefi_size = config["CONF_UEFI_PART_SIZE"].strip("\n")
    print("uefi:"+uefi_size)
    cmd       = ["parted", root_device, "mkpart", "primary", "1", uefi_size]
    run_cmd(cmd)

    # BOOT PART
    boot_size = config["CONF_BOOT_PART_SIZE"].strip("\n") 
    boot_boundery = str(int(uefi_size) + int(boot_size))
    cmd       = ['parted', root_device, "mkpart", "primary", uefi_size, boot_boundery] 
    run_cmd(cmd)

    psize = config['CONF_PHYS_ROOT_PART_SIZE'].strip("\n")
    phys_boundery = str(int(boot_boundery) + int(psize))
    cmd    = ['parted', root_device, "mkpart", "primary", boot_boundery, phys_boundery] 
    run_cmd(cmd)

    cmd=['parted', root_device, 'set', '1', 'boot', 'on']
    run_cmd(cmd)


#---------------------------------------------
#---------------------------------------------
def create_volumes(config):
    system_root = "/dev/" + config["CONF_ROOT_DEVICE"].strip('\n')
    system_root = system_root + "3"
    cmd = ['pvcreate', '-ff', '-y', system_root]
    run_cmd(cmd)
    
    vol_group_name = config["CONF_VOL_GROUP_NAME"].strip("\n")
    cmd = ['vgcreate', '-ff', vol_group_name, system_root] 
    run_cmd(cmd)

    root_vol_size = str(config["CONF_LOGICAL_ROOT_SIZE"].strip('\n'))+"G"
    cmd = ['lvcreate', '--yes', '-L', root_vol_size, '-n', 'root', vol_group_name]
    run_cmd(cmd)

    home_vol_size = str(config["CONF_LOGICAL_HOME_SIZE"].strip('\n')) + "G"
    cmd = ["lvcreate", '--yes', "-L", home_vol_size, '-n', 'home', vol_group_name]
    run_cmd(cmd)

    var_vol_size = str(config["CONF_LOGICAL_VAR_SIZE"].strip('\n')) + "G"
    cmd = ["lvcreate", '--yes', "-L", var_vol_size, '-n', 'var', vol_group_name]
    run_cmd(cmd)

    usr_vol_size = str(config["CONF_LOGICAL_USR_SIZE"].strip('\n')) + "G"
    cmd = ["lvcreate", '--yes', "-L", usr_vol_size, '-n', 'usr', vol_group_name]
    run_cmd(cmd)

    opt_vol_size = str(config["CONF_LOGICAL_OPT_SIZE"].strip('\n')) + "G"
    cmd = ["lvcreate", '--yes', "-L", opt_vol_size, '-n', 'opt', vol_group_name]
    run_cmd(cmd)

#---------------------------------------------
#---------------------------------------------
def format_volumes(config):

    system_root = "/dev/" + config["CONF_ROOT_DEVICE"].strip('\n')

    part1 = system_root + "1"
    cmd = ['mkfs.fat', part1]
    run_cmd(cmd)
   
    part2 = system_root + "2"
    cmd = ['mkfs.ext2', part2]
    run_cmd(cmd)

    vol_group_name = config["CONF_VOL_GROUP_NAME"].strip('\n')
    physix_root = "/dev/mapper/" + vol_group_name + "-root"
    cmd = ['mkfs.ext4', physix_root]
    run_cmd(cmd)

    vol_group_name = config["CONF_VOL_GROUP_NAME"].strip('\n')
    physix_home = "/dev/mapper/" + vol_group_name + "-home"
    cmd = ['mkfs.ext4', physix_home]
    run_cmd(cmd)

    vol_group_name = config["CONF_VOL_GROUP_NAME"].strip('\n')
    physix_var = "/dev/mapper/" + vol_group_name + "-var"
    cmd = ['mkfs.ext4', physix_var]
    run_cmd(cmd)

    vol_group_name = config["CONF_VOL_GROUP_NAME"].strip('\n')
    physix_usr = "/dev/mapper/" + vol_group_name + "-usr"
    cmd = ['mkfs.ext4', physix_usr]
    run_cmd(cmd)

    vol_group_name = config["CONF_VOL_GROUP_NAME"].strip('\n')
    physix_opt = "/dev/mapper/" + vol_group_name + "-opt"
    cmd = ['mkfs.ext4', physix_opt]
    run_cmd(cmd)

#---------------------------------------------
#--------------------------------------------
def mount_volumes(config):

    vol_group_name = "physix" 
    
    if not os.path.exists(BUILDROOT):
        os.mkdir(BUILDROOT,755)

    volume_root = "/dev/mapper/" + vol_group_name + "-root"
    cmd = ['mount', volume_root, BUILDROOT]
    run_cmd(cmd)

    home = BUILDROOT + "/home"
    os.mkdir(home,755) 
    volume_home = "/dev/mapper/" + vol_group_name + "-home"
    mnt_point = BUILDROOT + "/home"
    cmd = ['mount', volume_home, mnt_point]
    print(cmd)
    run_cmd(cmd)

    var = BUILDROOT + "/var"
    os.mkdir(var,755)
    volume_var = "/dev/mapper/" + vol_group_name + "-var"
    mnt_point = BUILDROOT + "/var"
    cmd = ['mount', volume_var, mnt_point]
    print(cmd)
    run_cmd(cmd)

    usr = BUILDROOT + "/usr"
    os.mkdir(usr,755)
    volume_usr = "/dev/mapper/" + vol_group_name + "-usr"
    mnt_point = BUILDROOT + "/usr"
    cmd = ['mount', volume_usr, mnt_point]
    print(cmd)
    run_cmd(cmd)

    opt = BUILDROOT + "/opt"
    os.mkdir(opt,755)
    volume_opt = "/dev/mapper/" + vol_group_name + "-opt"
    mnt_point = BUILDROOT + "/opt"
    cmd = ['mount', volume_opt, mnt_point]
    print(cmd)
    run_cmd(cmd)

    boot = BUILDROOT + "/boot"
    os.mkdir(boot,755)
    boot_part = "/dev/" + config["CONF_ROOT_DEVICE"].strip('\n') + "2"
    cmd = ['mount', boot_part, boot]
    print(cmd)
    run_cmd(cmd)



#---------------------------------------------
#--------------------------------------------
def check_md6sum():
    x = 1

#---------------------------------------------
#--------------------------------------------
def pull_sources(srclst):
    with open(srclst) as fd:
        for line in fd.readlines():
            if not line.startswith("#"):
                lst = line.split(",")

                archive = str(lst[0])
                URL = str(lst[1])
                SUM = str(lst[2])

                cmd = ['wget', '-q', '--continue', '--directory-prefix=/mnt/physix/opt/sources.physix/', URL]
                print("Downloading: " + archive)
                run_cmd(cmd)

#---------------------------------------------
#--------------------------------------------
def setup(config):

    if not os.path.exists(BUILDROOT+"/opt/buid-logs.physix"):
        os.mkdir(BUILDROOT+"/opt/buid-logs.physix",777)
    if not os.path.exists(BUILDROOT+"/opt/sources.physix"):
        os.mkdir(BUILDROOT+"/opt/sources.physix",770)

    cmd = ['ln','-sfv', '/usr/bin/base', '/usr/bin/sh']
    run_cmd(cmd)

    cmd = ['ln','-sfv', '/usr/bin/gawk', '/usr/bin/awk']
    run_cmd(cmd)

    src = BUILDROOT+"/tools"
    cmd = ['ln','-sfv', src, '/']
    run_cmd(cmd)

    try:
        if not pwd.getpwnam('physix'):
            cmd = ['useradd', '-s', '/bin/bash', '-m', 'physix']
            run_cmd(cmd)
    except:
        print('useradd fail')

    src  = os.getcwd() 
    dest = BUILDROOT + "/opt/"
    cmd = ['cp','-r',src, dest]
    run_cmd(cmd)
    
    #src = BUILDROOT + "/opt/physix/build-scripts/03-base-config/configs/physix-bash-profile"
    #dest = BUILDROOT + "/home/physix/.bash_profile"
    #cmd = ['cp', src, dest]
    #run_cmd(cmd)

    src  = BUILDROOT + "/opt/physix/build-scripts/03-base-config/configs/physix-bashrc"
    dest = "/home/physix/.bashrc"
    cmd = ['cp',src, dest]
    run_cmd(cmd)

    tools_dir = BUILDROOT + "/tools"
    cmd = ['chown', '-v', 'physix', tools_dir]
    run_cmd(cmd)

    sources_dir = BUILDROOT + "/opt/sources.physix"
    cmd = ['chown', '-v', 'physix', sources_dir]
    run_cmd(cmd)



if __name__ == '__main__' :
    #verify_checker()
    build_config = load_config()
    #create_partitions(build_config)
    #create_volumes(build_config)
    #format_volumes(build_config)
    #mount_volumes(build_config)

    print("Downloading Sources")
    pull_sources("./src-list.base")

    setup(build_config)


