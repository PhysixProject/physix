#!/usr/bin/python3
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies

import os
import sys
import json
import sqlite3
import tarfile
import logging
import datetime
import subprocess
from signal import signal
from signal import SIGINT
from optparse import OptionParser

from db import *
from utils import *
from definitions import *

BUILDROOT = "/mnt/physix"

def create_partitions(config):
    """
    Create partitions on disk.
    Return SUCCESS/FAILURE

    Keyword arguments:
    config -- dict: config options 
    """

    root_device = "/dev/" + config["CONF_ROOT_DEVICE"]
    rtn = root_device = root_device.strip("\n")

    of = 'of='+root_device
    ret_tpl = run_cmd(["dd", 'if=/dev/zero', of, 'bs=1M', 'count=5000'])
    if validate(ret_tpl, "Zero out beginning of device"):
        return FAILURE

    if config['CONF_UEFI_ENABLE'].lower() == 'y':
        ret_tpl = run_cmd(['parted', root_device, 'mklabel', 'gpt'])
        if validate(ret_tpl, "Create Disk label"):
            return FAILURE
    else:
        ret_tpl = run_cmd(['parted', root_device, 'mklabel', 'msdos'])
        if validate(ret_tpl, "Create Disk label"):
            return FAILURE

    # UEFI 
    uefi_size = config["CONF_UEFI_PART_SIZE"].strip("\n")
    ret_tpl = run_cmd(["parted", root_device, "mkpart", "primary", "1", uefi_size])
    if validate(ret_tpl, "Create UEFI Partition"):
        return FAILURE

    # BOOT PART
    boot_size = config["CONF_BOOT_PART_SIZE"].strip("\n")
    boot_boundery = str(int(uefi_size) + int(boot_size))
    ret_tpl = run_cmd(['parted', root_device, "mkpart", "primary", uefi_size, boot_boundery])
    if validate(ret_tpl, "Create /boot Partition"):
        return FAILURE

    psize = config['CONF_PHYS_ROOT_PART_SIZE'].strip("\n")
    phys_boundery = str(int(boot_boundery) + int(psize))
    ret_tpl = run_cmd(['parted', root_device, "mkpart", "primary", boot_boundery, phys_boundery])
    if validate(ret_tpl, "Create ROOT Partition"):
        return FAILURE

    ret_tpl = run_cmd(['parted', root_device, 'set', '1', 'boot', 'on'])
    if validate(ret_tpl, "Boot Flag Set to "+root_device):
        return FAILURE

    return SUCCESS


def create_volumes(config):
    """
    Create LVM volumes.
    Return SUCCESS/FAILURE

    Keyword arguments:
    config -- dict: config options
    """

    system_root = "/dev/" + config["CONF_ROOT_DEVICE"].strip('\n')
    if config['CONF_SKIP_PARTITIONING'].lower() == 'y':
        system_root = "/dev/" + str(config['CONF_INSTALL_DEV_PARTITION'])
    else:
        system_root = system_root + "3"

    if data_present(system_root):
        error("".join(["Data Found on:", system_root, "\nExiting..."]))
        return FAILURE

    ret_tpl = run_cmd(['pvcreate', '-ff', '-y', system_root])
    if validate(ret_tpl, "Physical Volume Create: "+system_root):
        return FAILURE

    vol_group_name = config["CONF_VOL_GROUP_NAME"].strip("\n")
    ret_tpl = run_cmd(['vgcreate', '-ff', vol_group_name, system_root])
    if validate(ret_tpl, ""):
        return FAILURE

    root_vol_size = str(config["CONF_LOGICAL_ROOT_SIZE"].strip('\n'))+"G"
    ret_tpl = run_cmd(['lvcreate', '--yes', '-L', root_vol_size, '-n', 'root', vol_group_name])
    if validate(ret_tpl, "Volume Create: root"):
        return FAILURE

    home_vol_size = str(config["CONF_LOGICAL_HOME_SIZE"].strip('\n')) + "G"
    ret_tpl = run_cmd(["lvcreate", '--yes', "-L", home_vol_size, '-n', 'home', vol_group_name])
    if validate(ret_tpl, "Volume Create: home"):
        return FAILURE

    var_vol_size = str(config["CONF_LOGICAL_VAR_SIZE"].strip('\n')) + "G"
    ret_tpl = run_cmd(["lvcreate", '--yes', "-L", var_vol_size, '-n', 'var', vol_group_name])
    if validate(ret_tpl, "Volume Create: var"):
        return FAILURE

    admin_vol_size = str(config["CONF_LOGICAL_ADMIN_SIZE"].strip('\n')) + "G"
    ret_tpl = run_cmd(["lvcreate", '--yes', "-L", admin_vol_size, '-n', 'admin', vol_group_name])
    if validate(ret_tpl, "Volume Create: admin"):
        return FAILURE

    return SUCCESS


def format_partitions(config):
    """
        Format partitions.
        Return SUCCESS/FAILURE

        Keyword arguments:
        config -- dict: config options
    """

    filesystem = config['CONF_ROOTPART_FS']
    mkfs_cmd  = "mkfs." + filesystem
    system_root = "/dev/" + config["CONF_ROOT_DEVICE"]

    part1 = system_root + "1"
    ret_tpl = run_cmd(['mkfs.fat', part1])
    if validate(ret_tpl, "mkfs.fat: " + part1):
        return FAILURE

    part2 = system_root + "2"
    ret_tpl = run_cmd(['mkfs.ext2', part2])
    if validate(ret_tpl, "mkfs.ext2: " + part2):
        return FAILURE
    return SUCCESS


def format_volumes(config):
    """
    Format LVM volumes and partitions.
    Return SUCCESS/FAILURE

    Keyword arguments:
    config -- dict: config options
    """

    filesystem = config['CONF_ROOTPART_FS']
    mkfs_cmd  = "mkfs." + filesystem
    vol_group_name = config["CONF_VOL_GROUP_NAME"]

    physix_root = "/dev/mapper/" + vol_group_name + "-root"
    ret_tpl = run_cmd([mkfs_cmd, physix_root])
    if validate(ret_tpl, mkfs_cmd+":"+physix_root):
        return FAILURE

    physix_home = "/dev/mapper/" + vol_group_name + "-home"
    ret_tpl = run_cmd([mkfs_cmd, physix_home])
    if validate(ret_tpl, mkfs_cmd+":"+physix_home):
        return FAILURE

    physix_var = "/dev/mapper/" + vol_group_name + "-var"
    ret_tpl = run_cmd([mkfs_cmd, physix_var])
    if validate(ret_tpl, mkfs_cmd+""+physix_var):
        return FAILURE

    physix_admin = "/dev/mapper/" + vol_group_name + "-admin"
    ret_tpl = run_cmd([mkfs_cmd, physix_admin])
    if validate(ret_tpl, mkfs_cmd+":"+ physix_admin):
        return FAILURE

    return SUCCESS


def mount_partitions(config):
    """
        Mount partitions.
        Return SUCCESS/FAILURE

        Keyword arguments:
        config -- dict: config options
    """

    boot = BUILDROOT + "/boot"
    os.mkdir(boot, 0o755)
    if not config["CONF_BOOT_DEV_PART"] == "":
        boot_part = "/dev/" + config["CONF_BOOT_DEV_PART"].strip('\n')
        ret_tpl = run_cmd(['mount', boot_part, boot])
        if validate(ret_tpl, "Mount: " + boot_part):
            return FAILURE

    if config['CONF_UEFI_ENABLE'].lower() == 'y':
        efi_dir = BUILDROOT + "/boot/efi"
        if not os.path.exists(efi_dir):
            os.mkdir(efi_dir, 0o755)

        efi_boot_part = "/dev/" + config["CONF_UEFI_DEV_PART"].strip('\n')
        ret_tpl = run_cmd(['mount', efi_boot_part, efi_dir])
        if validate(ret_tpl, "Mount: " + efi_boot_part):
            return FAILURE

    return SUCCESS


def mount_volumes(config):
    """
    Mount volumes and partitions.
    Return SUCCESS/FAILURE

    Keyword arguments:
    config -- dict: config options
    """

    filesystem = config['CONF_ROOTPART_FS']
    vol_group_name = config["CONF_VOL_GROUP_NAME"]

    if not os.path.exists(BUILDROOT):
        os.mkdir(BUILDROOT, 755)

    volume_root = "/dev/mapper/" + vol_group_name + "-root"
    ret_tpl = run_cmd(['mount', volume_root, BUILDROOT])
    if validate(ret_tpl, "Mount: "+volume_root):
        return FAILURE

    if filesystem == 'btrfs':
        btrfs_subvolume = BUILDROOT + "/" + "STACK_0"
        ret_tpl = run_cmd(['btrfs', 'subvolume', 'create', btrfs_subvolume])
        if validate(ret_tpl, "Create  subvolume: STACK_0 on physix-root"):
            return FAILURE

        vol_id = get_subvol_id(BUILDROOT, "STACK_0")
        if vol_id == None:
            return FAILURE
        ret_tpl = run_cmd(['btrfs', 'subvolume', 'set-default', vol_id, BUILDROOT])
        if validate(ret_tpl, "btrfs subvolume set-default:"+vol_id):
             return FAILURE

        ret_tpl = run_cmd(['umount', '/mnt/physix'])
        if validate(ret_tpl, "unmount /mnt/physix"):
            return FAILURE

        ret_tpl = run_cmd(['mount', '-t', 'btrfs', '-o', 'subvol=STACK_0', volume_root, '/mnt/physix'])
        if validate(ret_tpl, "Mount physix-root subvolume: STACK_0"):
            return FAILURE


    # TODO: create root as alternative FS

    mnt_point = BUILDROOT + "/home"
    os.mkdir(mnt_point, 0o755)
    volume_home = "/dev/mapper/" + vol_group_name + "-home"
    ret_tpl = run_cmd(['mount', volume_home, mnt_point])
    if validate(ret_tpl, "Mount: " + volume_home):
        return FAILURE

    var = BUILDROOT + "/var"
    os.mkdir(var, 0o755)
    volume_var = "/dev/mapper/" + vol_group_name + "-var"
    mnt_point = BUILDROOT + "/var"
    ret_tpl = run_cmd(['mount', volume_var, mnt_point])
    if validate(ret_tpl, "Mount: " + volume_var):
        return FAILURE

    opt = BUILDROOT + "/opt"
    opt_admin = opt + "/admin"
    mnt_point = opt_admin
    os.mkdir(opt, 0o755)
    os.mkdir(opt_admin, 0o755)
    volume_admin = "/dev/mapper/" + vol_group_name + "-admin"
    ret_tpl = run_cmd(['mount', volume_admin, mnt_point])
    if validate(ret_tpl, "Mount: " + volume_admin):
        return FAILURE

    return SUCCESS


def pull_sources(recipe, dest):
    """
    Download sources defined in a recipe.
    Return SUCCESS/FAILURE

    Keyword arguments:
    recipe -- dict: config options
    dest -- destination target path of sources
    """

    dir_prefix = '--directory-prefix=' + dest
    rsize = len(recipe['build_queue'])

    if not os.path.exists(dest):
        os.mkdir(dest, 0o755)
        if not os.path.exists(dest):
            error("Destination Path Creation Failed:" + dest)

    pull_lst = []
    for i in range(rsize):
        sources = recipe[str(i)]["physix_sources"]
        for key in sources.keys():
            pull_lst.append(key)

    for url in pull_lst:
        if url:
            ret_tpl = run_cmd(['wget', '-q', '--continue', dir_prefix, url])
            if validate(ret_tpl, "Download: "+url, True):
                return FAILURE

    return SUCCESS


def setup_build_env(element, context):
    """
    Setup build directory.
    Return SUCCESS/FAILURE

    Keyword arguments:
    element -- dict: represents a package to be built
    context -- string: used to determine path of build directory
    """

    src_prefix = get_sources_prefix(context)
    if src_prefix == False:
        return FAILURE
    bb_path = os.path.join(src_prefix, "BUILDBOX")

    if not refresh_build_box(context):
        error("refresh_build_box")
        return FAILURE

    physix_prefix = get_physix_prefix(context)
    if physix_prefix == False:
        return FAILURE

    include = os.path.join(physix_prefix, "include.sh")
    ret_tpl = run_cmd(['cp', include, bb_path])
    if validate(ret_tpl, 'Copy include.sh to BUILDBOX'):
        return FAILURE

    buildconf =  os.path.join(physix_prefix, "physix.conf")
    ret_tpl = run_cmd(['cp', buildconf, bb_path])
    if validate(ret_tpl, 'Copy physix.conf to BUILDBOX'):
        return FAILURE

    for patch in element["patches"]:
        patch_path = os.path.join(src_prefix, patch)
        ret_tpl = run_cmd(['cp', patch_path, bb_path])
        if validate(ret_tpl, 'Copy patch to BUILDBOX'):
            return FAILURE

    for archive in element["archives"]:
        #archive_path = src_path + archive
        archive_path = os.path.join(src_prefix, archive)
        ret_tpl = run_cmd(['cp', archive_path, bb_path])
        if validate(ret_tpl, 'Copy archive to BUILDBOX'):
            return FAILURE

    return SUCCESS


def setup(config):
    """
    Setup Base system environment in preperation for build.
    Return SUCCESS/FAILURE

    Keyword arguments:
    config -- dict: config options
    """

    if not os.path.exists(BUILDROOT+"/opt"):
        os.mkdir(BUILDROOT+"/opt", 755)
    if not os.path.exists(BUILDROOT_ADMIN_DIR_PATH):
        os.mkdir(BUILDROOT_ADMIN_DIR_PATH, 755)
    if not os.path.exists(BUILDROOT_PHYSIX_LOGS_DIR):
        os.mkdir(BUILDROOT_PHYSIX_LOGS_DIR, 777)
    if not os.path.exists(BUILDROOT_SOURCES_DIR_PATH):
        os.mkdir(BUILDROOT_SOURCES_DIR_PATH, 770)

    # First find bash
    ret_tpl = run_cmd(['ln', '-sfv', '/usr/bin/bash', '/usr/bin/sh'])
    if validate(ret_tpl, "link bash to 'sh/bash'"):
        return FAILURE

    # First find gawk
    ret_tpl = run_cmd(['ln', '-sfv', '/usr/bin/gawk', '/usr/bin/awk'])
    if validate(ret_tpl, "link gawk to 'awk/gawk'"):
        return FAILURE

    # First find bison
    ret_tpl = run_cmd(['ln', '-sfv', '/usr/bin/bison', '/usr/bin/yacc'])
    if validate(ret_tpl, "link gawk to 'yacc/bison'"):
        return FAILURE

    tools = BUILDROOT+"/tools"
    ret_tpl = run_cmd(['ln', '-sfv', tools, '/'])
    if validate(ret_tpl, "link tools dir"):
        return FAILURE

    (rtn, out, err) = run_cmd(['grep', 'physix', '/etc/passwd'])
    if int(rtn) != 0:
        ret_tpl = run_cmd(['useradd', '-s', '/bin/bash', '-m', 'physix', '-U'])
        if validate(ret_tpl, "useradd physix"):
            return FAILURE

    src = str(os.getcwd()) + "/build-groups/03-base-config/configs/physix-bashrc"
    dest = "/home/physix/.bashrc"
    ret_tpl = run_cmd(['cp', src, dest])
    if validate(ret_tpl, "set physix user's .bashrc file"):
        return FAILURE

    tools_dir = BUILDROOT + "/tools"
    os.mkdir(tools_dir, 0o755)
    ret_tpl = run_cmd(['chown', '-v', 'physix', tools_dir])
    if validate(ret_tpl, "chown "+tools_dir):
        return FAILURE

    ret_tpl = run_cmd(['chmod', '755', tools_dir])
    if validate(ret_tpl, "chmod 775 "+tools_dir):
        return FAILURE

    ret_tpl = run_cmd(['chown', '-v', 'physix', BUILDROOT_SOURCES_DIR_PATH])
    if validate(ret_tpl, "chown "+BUILDROOT_SOURCES_DIR_PATH):
        return FAILURE

    ret_tpl = run_cmd(['chmod', '755', BUILDROOT_SOURCES_DIR_PATH])
    if validate(ret_tpl, "chmod 755 "+BUILDROOT_SOURCES_DIR_PATH):
        return FAILURE

    ret_tpl = run_cmd(['mv', os.getcwd(), BUILDROOT_ADMIN_DIR_PATH])
    if validate(ret_tpl, "Move physix repo to "+BUILDROOT_ADMIN_DIR_PATH):
        return FAILURE

    if init_db_tables():
        error("Initialization of DB tables")
        return FAILURE

    return SUCCESS 


def build_toolchain(recipe, context, start, stop):
    """
    Build the temorary toolchain from recipe.
    Return SUCCESS/FAILURE

    Keyword arguments:
    recipe -- dict: config that defines ordered list of sources and assiciated 
              build instructions.
    context -- string: used to determine path of build directory.
    start -- integer: defines the position in the recipe to start building at.
    stop -- integer: defines the position in the recipe to stop building at.
    """

    commit_id = get_curr_commit_id()
    if commit_id == None:
        error("Could not retrieve git commit id. Exiting.")
        return FAILURE

    buildq = recipe['build_queue']
    for i in range(start, stop):
        build_id = str(buildq[i])
        element  = recipe[build_id]

        stat = " ".join(["Build [", str(i), "/", str(int(len(buildq)-1)), "] Toolchain" ] )
        info(stat)

        if setup_build_env(element, context):
            return FAILURE

        ''' Fails on error '''
        if unpack(element, context):
            return FAILURE

        """ Dir name of First tarball in list is passed as arg to the 
            build script """
        build_src = ''
        if element["archives"] != []:
            bsp = os.path.join(get_sources_prefix(context), str(element["archives"][0]))
            build_src = top_most_dir(bsp)

        build_file = os.path.join(BUILDROOT_BUILDSCRIPTS_DIR_PATH,
                              str(element["group"]),
                              str(element["package"]),
                              "build.sh")

        cwd = BUILDROOT_BUILDBOX_DIR_PATH + build_src
        log_name = 'toolchain' + "-" + str(element["package"])
        os.chdir(cwd)

        cmd = [build_file, 'prep']
        ret_tpl = run_cmd_log_io_as_physix_user(cmd, log_name, context, cwd)
        if validate(ret_tpl, "prep(): "+str(cmd), True):
            unset_build_lock()
            return FAILURE

        cmd = [build_file, 'config'] 
        ret_tpl = run_cmd_log_io_as_physix_user(cmd, log_name, context, cwd)
        if validate(ret_tpl, "config(): "+str(cmd), True):
            unset_build_lock()
            return FAILURE

        cmd = [build_file, 'build']
        ret_tpl = run_cmd_log_io_as_physix_user(cmd, log_name, context, cwd)
        if validate(ret_tpl, "build(): "+str(cmd), True):
            unset_build_lock()
            return FAILURE
 
        cmd = [build_file, 'build_install']
        ret_tpl = run_cmd_log_io_as_root_user(cmd, log_name, "")
        if validate(ret_tpl, "Build_install(): " + str(cmd), True):
            return FAILURE

        os.chdir(BUILDROOT_PHYSIX_DIR)
        if write_db_stack_entry('NON-CHRT', commit_id, 'BUILD', build_src, str(element["package"])):
            error("write_db_stack_entry failed")
            return FAILURE

    return SUCCESS


def build_recipe(recipe, context, start, stop):
    """
    Build/install sources from  a recipe.
    Return SUCCESS/FAILURE

    Keyword arguments:
    recipe -- dict: config that defines ordered list of sources and assiciated 
              build instructions.
    context -- string: used to determine path of build directory.
    start -- integer: defines the position in the recipe to start building at.
    stop -- integer: defines the position in the recipe to stop building at.
    """

    commit_id = get_curr_commit_id()
    if commit_id == None:
        error("Could not retrieve git commit id. Exiting.")
        return FAILURE

    buildq = recipe['build_queue']
    for i in range(start, stop):
        build_id = str(buildq[i])
        element  = recipe[build_id]

        stat = " ".join(["Building [", str(i), "/", str(int(len(buildq)-1)), "]"])
        info(stat)

        if set_build_lock():
            return FAILURE

        if setup_build_env(element, context):
            return FAILURE

        unpack(element, context)

        """ Dir name of First tarball in list, is taken/used/assumed to be
            the build directory we want to chdir into """
        if element["archives"] != []:
            bsp = SOURCES_DIR_PATH + str(element["archives"][0])
            build_src = top_most_dir(bsp)
        else:
            build_src = ''

        build_file = os.path.join(BUILDSCRIPTS_DIR_PATH,
                              str(element["group"]),
                              str(element["package"]),
                              "build.sh")
        log_name = get_name_current_stack('CHRT') + "-" + str(element["package"])

        # CHDIR
        os.chdir(BUILDBOX_DIR_PATH + build_src)

        cwd = BUILDBOX_DIR_PATH + build_src
        cmd = [build_file, 'prep']

        info("Executing prep() as physix user: " + "[" + str(i) + "] " + str(cmd))
        ret_tpl = run_cmd_log_io_as_physix_user(cmd, log_name, context, cwd)
        if validate(ret_tpl, "prep(): "+str(cmd), True):
            unset_build_lock()
            return FAILURE

        cmd = [build_file, 'config']
        info("Executing config() as physix user: " + "[" + str(i) + "] " + str(cmd))
        ret_tpl = run_cmd_log_io_as_physix_user(cmd, log_name, context, cwd)
        if validate(ret_tpl, "config(): "+str(cmd), True):
            unset_build_lock()
            return FAILURE

        cmd = [build_file, 'build']
        info("Executing build() as physix user: " + "[" + str(i) + "] " + str(cmd))
        ret_tpl = run_cmd_log_io_as_physix_user(cmd, log_name, context, cwd)
        if validate(ret_tpl, "Build(): "+str(cmd), True):
            unset_build_lock()
            return FAILURE

        cmd = [build_file, 'build_install']
        info("Executing build_install() as root user: " + "[" + str(i) + "] " + str(cmd))
        ret_tpl = run_cmd_log_io_as_root_user(cmd, log_name, context)
        if validate(ret_tpl, "Build_install(): "+str(cmd), True):
            unset_build_lock()
            return FAILURE

        # CHDIR
        #os.chdir('/opt/admin/physix')
        os.chdir(PHYSIX_DIR)

        if unset_build_lock():
            return FAILURE

        if write_db_stack_entry('CHRT', commit_id, 'BUILD', build_src, str(element["package"])):
            error("write_db_stack_entry failed, but installation was successful")
            return FAILURE



def build_base(recipe, context, start, stop):
    """
    Build/install sources from base system recipe.
    Return SUCCESS/FAILURE

    Keyword arguments:
    recipe -- dict: config that defines ordered list of sources and assiciated 
              build instructions.
    context -- string: used to determine path of build directory.
    start -- integer: defines the position in the recipe to start building at.
    stop -- integer: defines the position in the recipe to stop building at.
    """

    commit_id = get_curr_commit_id()
    if commit_id == None:
        error("Could not retrieve git commit id. Exiting.")
        return FAILURE

    if start == 0:
        cmd = ['/mnt/physix/opt/admin/physix/build-groups/02-base/2.000-base-build-prep/build.sh']
        ret_tpl = run_cmd_log_io_as_root_user(cmd, "2.000-base-build-prep.sh", "")
        if validate(ret_tpl, "Build: " + str(cmd)):
            return FAILURE

    buildq = recipe['build_queue']
    for i in range(start, stop):
        build_id = str(buildq[i])
        element  = recipe[build_id]

        stat = " ".join(["Building [", str(i), "/", str(int(len(buildq)-1)), "] Base System" ] )
        info(stat)

        if setup_build_env(element, context):
            error("Failed to stup build_env")
            return FAILURE

        if unpack(element, context):
            error("Failed to unpack")
            return FAILURE

        """ Dir name of First tarball in list, is passed as arg to the 
            build script """
        if element["archives"] != []:
            bsp = BUILDROOT_SOURCES_DIR_PATH + str(element["archives"][0])
            build_src = top_most_dir(bsp)
        else:
            build_src = ''

        stack_script = "STACk_0-" + str(element["package"])

        cmd = ['/mnt/physix/opt/admin/physix/build-groups/02-base/000-chroot_stub.sh',
               str(element["package"]),
               build_src]
        info("Executing Build: " + "[" + str(i) + "] " + str(cmd))
        ret_tpl = run_cmd_log_io_as_root_user(cmd, stack_script, "")
        if validate(ret_tpl, "Build: " + str(cmd), True):
            return FAILURE

        if write_db_stack_entry('NON-CHRT', commit_id, 'BUILD', build_src, str(element["package"])):
            error("write_db_stack_entry failed, but installation was successful")
            return FAILURE



def config_base_system(recipe, context, start, stop):
    """
    Configure the base system from recipe.
    Note: utilizes special case for setting user passwords.
    Return SUCCESS/FAILURE

    Keyword arguments:
    recipe -- dict: config that defines ordered list of sources and assiciated 
              build instructions.
    context -- string: used to determine path of build directory.
    start -- integer: defines the position in the recipe to start building at.
    stop -- integer: defines the position in the recipe to stop building at.
    """

    commit_id = get_curr_commit_id()
    if commit_id == None:
        error("Could not retrieve git commit id. Exiting.")
        return FAILURE

    buildq = recipe['build_queue']
    for i in range(start, stop):
        build_id = str(buildq[i])
        element  = recipe[build_id]

        stat = " ".join(["Building [", str(i), "/", str(int(len(buildq)-1)), "] Config Base System" ])
        info(stat)

        if setup_build_env(element, context):
            error("Failed to stup build_env")
            return False

        """ Fails on error """
        if unpack(element, context):
            return FAILURE

        """ Dir name of First tarball in list, is passed as arg to the 
            build script """
        if element["archives"] != []:
            bsp = BUILDROOT_SOURCES_DIR_PATH + str(element["archives"][0])
            build_src = top_most_dir(bsp)
        else:
            build_src = ''

        stack_script = "STACk_0-" + str(element["package"])

        cmd = ['/mnt/physix/opt/admin/physix/build-groups/03-base-config/000-conf_chrrot_stub.sh',
               str(element["package"]),
               build_src]
        info("Executing Build: " + "[" + str(i) + "] " + str(cmd))
        ret_tpl = run_cmd_log_io_as_root_user(cmd, stack_script, "")
        if validate(ret_tpl, "Build: "+str(cmd), True):
            return FAILURE

        if write_db_stack_entry('NON-CHRT', commit_id, 'BUILD', build_src, str(element["package"])):
            error("write_db_stack_entry failed, but installation was successful")
            return FAILURE


    """ Special case for user to set password without logging"""
    cmd = ['/mnt/physix/opt/admin/physix/build-groups/03-base-config/000-conf_chrrot_stub.sh',
           '3.111-set-passwd']
    run_cmd_live(cmd)


def do_physix_conf_init(options):
    """
    High level function whcih calls lower functions that:
      - create partitions
      - create volumes
      - format partitions
      - format volumes
      - mount volumes
    Return SUCCESS/FAILURE

    Keyword arguments:
    options -- dict: config
    """

    logging.basicConfig(filename='/tmp/physix-build.log', level=logging.DEBUG)
    
    BUILD_CONFIG = load_physix_config(options.physix_conf)

    # rename sysreq_check
    if verify_checker(BUILD_CONFIG):
        error("Systemd Requirement check")
        return FAILURE
    ok("Systemd Requirement check")

    if BUILD_CONFIG['CONF_SKIP_PARTITIONING'].lower() == 'n':
        """ We expect a blank device """
        if num_root_device_partitions(BUILD_CONFIG) > 0:
            error("Found Existing partition(s) on CONF_ROOT_DEVICE, Please remove them and restart this opperation")
            return FAILURE

        info("Creating Partitions")
        if create_partitions(BUILD_CONFIG):
            error("Creating Partitions")
            return FAILURE
        ok("Created Partitions")

        info("Format Partitions")
        if format_partitions(BUILD_CONFIG):
            error("Format Partitions")
            return FAILURE
        ok("Formatted Partitions")

        info("Creating Volumes")
        if create_volumes(BUILD_CONFIG):
            error("Creating Volumes")
            return FAILURE
        ok("Created Volumes")

    elif BUILD_CONFIG['CONF_SKIP_PARTITIONING'].lower() == 'y':
        """ Skip partitioning and setup volumes on CONF_CUSTOM_PARTITION """
        info("Creating Volumes")
        if create_volumes(BUILD_CONFIG):
            error("Creating Volumes")
            return FAILURE
        ok("Created Volumes")
    else:
        error("Invalid config")
        return FAILURE

    info("Formating Volumes")
    if format_volumes(BUILD_CONFIG):
        error("Formating Volumes")
        return FAILURE
    ok("Formatted Volumes")

    info("Mounting Volumes")
    if mount_volumes(BUILD_CONFIG):
        error("Mounting Volumes")
        return FAILURE
    ok("Mounted Volumes")

    info("Mounting Partitions")
    if mount_partitions(BUILD_CONFIG):
        error("Mounting Partitions")
        return FAILURE
    ok("Mounted Partitions")

    if setup(BUILD_CONFIG):
        return FAILURE

    info("------------------------------------")
    info("- Build initialization completete!")
    info("- Next Step: Build the toolchain.")
    info("- 1. cd /mnt/physix/opt/admin/physix")
    info("- 2. ./catalyst -p 01-toolchain.json")
    info("- 3. ./catalyst -t 01-toolchain.json")
    info("------------------------------------")
    return SUCCESS


def do_toolchain_build(options):
    """
    Initial function in code path to build the toolchain.
    Return SUCCESS/FAILURE

    Keyword arguments:
    options -- dict: config options.
    """

    start = 0
    stop = 0

    if options.start_number:
        start = int(options.start_number)

    if os.path.exists("/tmp/physix-build.log"):
        CMD = ['mv', '/tmp/physix-build.log', BUILDROOT_PHYSIX_LOGS_DIR]
        if (run_cmd(CMD))[1] != 0:
            ok("Relocated physix-build.log to "+BUILDROOT_PHYSIX_LOGS_DIR)
    logging.basicConfig(filename=BUILDROOT_PHYSIX_LOGFILE,
                            level=logging.DEBUG)
    info("build toolchain...")
    RECIPE_NAME = str(options.toolchain_conf)
    RECIPE = load_recipe(RECIPE_NAME)

    result = verify_build_bounderies(options, RECIPE)
    if result == (None, None):
        return FAILURE
    start = result[0]
    stop = result[1]

    if verify_recipe_md5(RECIPE, "NON-CHRT"):
        error("verify_recipe_md5")
        return FAILURE

    if build_toolchain(RECIPE, "NON-CHRT", start, stop):
        return FAILURE

    info("------------------------------------")
    info("- Toolchain Build Completete!")
    info("- Next Step: Build the Base System.")
    info("- ./catalyst -p 02-base-system.json")
    info("- ./catalyst -s 02-base-system.json")
    info("------------------------------------")
    return SUCCESS


def do_base_build(options):
    """
    Initial function in code path to build base recipe.
    Return SUCCESS/FAILURE

    Keyword arguments:
    options -- dict: config options.
    """

    start = 0
    stop = 0
    if options.start_number:
        start = int(options.start_number)

    logging.basicConfig(filename=BUILDROOT_PHYSIX_LOGFILE,
                            level=logging.DEBUG)
    info("Building Base System...")
    RECIPE_NAME = str(options.base_conf)
    RECIPE = load_recipe(RECIPE_NAME)

    result = verify_build_bounderies(options, RECIPE)
    if result == (None, None):
        return FAILURE
    start = result[0]
    stop = result[1]

    if verify_recipe_md5(RECIPE, "NON-CHRT"):
        error("verify_recipe_md5")
        return FAILURE

    if build_base(RECIPE, "NON-CHRT", start, stop):
        return FAILURE

    info("------------------------------------")
    info("- Base System Build Completete!")
    info("- Next Step: Configure Base System")
    info("- 1. ./catalyst -c 03-config-base.json")
    info("------------------------------------")
    return SUCCESS


def do_config_base(options):
    """
    Initial function in code path to build configuration recipe.
    Return SUCCESS/FAILURE

    Keyword arguments:
    options -- dict: config options.
    """

    start = 0
    stop = 0
    if options.start_number:
        start = int(options.start_number)

    logging.basicConfig(filename='/mnt/physix/opt/admin/logs.physix/physix-build.log',
                            level=logging.DEBUG)
    info("Configure Base System...")
    info("Building Base System...")
    RECIPE_NAME = str(options.configure_base_conf)
    RECIPE = load_recipe(RECIPE_NAME)

    result = verify_build_bounderies(options, RECIPE)
    if result == (None, None):
        return FAILURE
    start = result[0]
    stop = result[1]

    if config_base_system(RECIPE, "NON-CHRT", start, stop):
        return FAILURE

    info("----------------------------------------------------------------------")
    info("- Base System Configured!")
    info("- Next Steps:")
    info("- 0. A mockup grub config has been moved to /boot/physix-grub.cfg")
    info("     Use this example as a starting point to configure your /boot/grub/grub.cfg")
    info("- 1. reboot")
    info("- 2. login")
    info("- 3. Take a snapshot of the system:\n  cd /opt/admin/physix ; ./catalyst -r SNAPSHOT_NAME")
    info("- 4. Download root of trust certs: `make-ca -g`")
    info("- 5. Build Utilities:")
    info("     cd /opt/admin/physix")
    info("     ./catalyst -p 04-utilities.json")
    info("     ./catalyst -b 04-utilities.json")
    info("- 6. See README for further build instructions.")
    info("----------------------------------------------------------------------")
    return SUCCESS


def do_build_recipe(options):
    """
    Initial function in code path to build recipe.
    Return SUCCESS/FAILURE

    Keyword arguments:
    options -- dict: config options.
    """

    start = 0
    stop = 0

    logging.basicConfig(filename='/opt/admin/logs.physix/physix-build.log',
                            level=logging.DEBUG)
    info("Building Recipe")
    RECIPE_NAME = str(options.build_recipe)
    RECIPE = load_recipe(RECIPE_NAME)

    result = verify_build_bounderies(options, RECIPE)
    if result == (None, None):
        return FAILURE
    start = result[0]
    stop = result[1]

    if verify_recipe_md5(RECIPE, "CHRT"):
        error("verify_recipe_md5")
        return FAILURE

    info("Building: "+ str(start) + "-" + str(stop))
    if build_recipe(RECIPE, "CHRT", start, stop):
        return FAILURE

    info("------------------------------------")
    info("- Build Complete")
    info("------------------------------------")
    return SUCCESS


def do_list_stack(options):
    """
    Initial function in code path for listing the system stack.
    Return SUCCESS/FAILURE

    Keyword arguments:
    options -- dict: config options.
    """
    if os.path.exists('/mnt/physix/opt/admin/physix'):
        context = 'NON-CHRT'
    else:
        context = 'CHRT'

    conn = get_db_connection(context)
    if list_stack(conn):
        error("list_stack failed")
    conn.close()
    return SUCCESS


def do_pull_sources(options):
    """
    Initial function in code path for downloading sources.
    Return SUCCESS/FAILURE

    Keyword arguments:
    options -- dict: config options.
    """

    context = 'NON-CHRT'
    dest = BUILDROOT_SOURCES_DIR_PATH

    if not os.path.exists(dest):
        dest = SOURCES_DIR_PATH
        context = "CHRT"
        if not os.path.exists(dest):
            error("Pull Sources: Invalid Destination")
            return FAILURE

    info("Downloading Sources to: "+dest)
    recipe_name = str(options.pull_sources)
    recipe = load_recipe(recipe_name)
    if pull_sources(recipe, dest) == FAILURE:
        return FAILURE

    if verify_recipe_md5(recipe, context) == FAILURE:
        return FAILURE

    return SUCCESS


def do_list_snapshots():
    """
    Mount the master subvolume, and read the names of the present snapshots.
    Return SUCCESS/FAILURE
    """

    mntpoint = TMP_MNTPOINT_DIR

    if 'btrfs' != root_fs_type():
        error("File system snapshots are not available for " + str(root_fs_type()))
        return FAILURE

    if not os.path.exists(TMP_MNTPOINT_DIR):
        try:
            os.makedirs(TMP_MNTPOINT_DIR, 0o755)
        except Exception as e:
            info(str(e))

    # Just in case it is already mounted.
    ret_tpl = run_cmd(['umount', TMP_MNTPOINT_DIR])

    physix_root = root_lvm_path()
    if physix_root == None:
        return FAILURE

    ret_tpl = run_cmd(['mount', '-o', 'subvolid=5', physix_root, TMP_MNTPOINT_DIR])
    if validate(ret_tpl, "Mount physix-root to tmp mount point"):
        return FAILURE

    dir_listing = os.listdir(TMP_MNTPOINT_DIR)
    print("Available Snapshots:")
    for snap_name in dir_listing:
        print ("  "+snap_name)

    ret_tpl = run_cmd(['umount', TMP_MNTPOINT_DIR])
    if validate(ret_tpl, "umount mount point"):
        return FAILURE


def do_snapshot(options):
    """
    Write Btrfs File system snapshot to disk. Record event in DB.physix.
    Return SUCCESS/FAILURE

    Keyword arguments:
    options -- dict: config options.
    """
    snap_name = options.snapshot

    if '/mnt/physix/' in str(os.getcwd()):
        error("Snapshots not supported during Initial Base build process")
        return FAILURE

    if 'btrfs' != root_fs_type():
        error("File system snapshots are not available for " + str(root_fs_type()))
        return FAILURE

    if not name_is_valid(snap_name):
        return FAILURE

    if not os.path.exists(TMP_MNTPOINT_DIR):
        try:
            os.makedirs(TMP_MNTPOINT_DIR, 0o755)
        except Exception as e:
            info(str(e))
            return FAILURE

    commit_id = get_curr_commit_id()
    if commit_id == None:
        error("Could not retrieve git commit id. Exiting.")
        return FAILURE

    db = get_db_connection('CHRT')    
    if db:
        curr_stack = get_name_current_stack('CHRT')
    else:
        error("DB connection == None")
        return FAILURE

    if index_already_exists(snap_name):
        error("Stack: "+snap_name+" Already Exits.")
        return FAILURE

    # Just in case it is already mounted.
    ret_tpl = run_cmd(['umount', TMP_MNTPOINT_DIR])

    physix_root = root_lvm_path()
    if physix_root == None:
        return FAILURE

    ret_tpl = run_cmd(['mount', '-o', 'subvolid=5', physix_root, TMP_MNTPOINT_DIR])
    if validate(ret_tpl, "Mount root to tmp mount point"):
        return FAILURE

    curr_stack_path = TMP_MNTPOINT_DIR + curr_stack
    snap_stack_path = TMP_MNTPOINT_DIR + snap_name

    run_cmd(['sync'])
    run_cmd(['sync'])

    ret_tpl = run_cmd(['btrfs', 'subvolume', 'snapshot', curr_stack_path, snap_stack_path])
    if validate(ret_tpl, "Record Snapshot:"+snap_name):
        ret_tpl = run_cmd(['umount', TMP_MNTPOINT_DIR])
        validate(ret_tpl, "umount mntpoint:")
        return FAILURE

    entry = (date(), 'SNAPSHOT', commit_id, snap_name, '', '')
    sql = "INSERT INTO "+ curr_stack + " (TIME,OP,COMMITID,SNAPID,PKG,SCRIPT) VALUES(?,?,?,?,?,?) "
    if exec_sql(db, sql, entry):
        error("DB: Failed to record snapshot to stack"+curr_stack)
        return FAILURE
 
    sql_create_table = " CREATE TABLE IF NOT EXISTS "+ snap_name  +" ( \
                                ID integer PRIMARY KEY AUTOINCREMENT,  \
                                TIME text NOT NULL,                    \
                                OP text NOT NULL,                      \
                                COMMITID text,                         \
                                SNAPID text,                           \
                                PKG text,                              \
                                SCRIPT text); "
    if exec_sql(db, sql_create_table, ""):
        error("DB: Failed to record snapshot:"+snap_name)
        return FAILURE

    sql_copy_table = "INSERT INTO "+ snap_name +" SELECT * FROM " + curr_stack + ";"
    if exec_sql(db, sql_copy_table, ""):
        error("DB: Failed to copy data from curr_tack to new snapshot")
        return FAILURE

    ret_tpl = run_cmd(['umount', TMP_MNTPOINT_DIR])
    if validate(ret_tpl, "Failed to umount mntpoint after taking snapshot and recording to DB"):
        return FAILURE

    ok("System Snapshot Successful: "+snap_name)
    return SUCCESS


def do_delete_snapshot(options):
    """
    Delete snapshot (btrfs subvolume) from File system and remove
    entries of its existence from the stack stack table.
    Return SUCCESS/FAILURE

    Keyword arguments:
    options -- dict: config options.
    """

    snap_name = options.delete_snap

    if '/mnt/physix/' in str(os.getcwd()):
        error("Snapshot delete is not supported during Initial Base build process")
        return FAILURE

    curr_stack = get_name_current_stack('CHRT')
    if curr_stack == snap_name:
        error("Can not delete currently running snapshot")
        return FAILURE

    if not os.path.exists(TMP_MNTPOINT_DIR):
        try:
            os.makedirs(TMP_MNTPOINT_DIR, 0o755)
        except Exception as e:
            info(str(e))
            return FAILURE

    db  = get_db_connection('CHRT')
    if db:
        curr_stack = get_name_current_stack('CHRT')
    else:
        error("DB connection == None")
        return FAILURE

    # Just in case it is already mounted.
    ret_tpl = run_cmd(['umount', TMP_MNTPOINT_DIR])

    physix_root = root_lvm_path()
    if physix_root == None:
        return FAILURE

    ret_tpl = run_cmd(['mount', '-o', 'subvolid=5', physix_root, TMP_MNTPOINT_DIR])
    if validate(ret_tpl, "Mount physix-root to tmp mount point"):
        return FAILURE

    delete_snap_entry = "DELETE FROM " + curr_stack + " WHERE SNAPID=\"" + snap_name + "\";"
    if exec_sql(db, delete_snap_entry, ""):
        error("DB: Failed to delete snap entry" + snap_name)
        return FAILURE

    drop_table = "DROP TABLE " + snap_name + ";"
    if exec_sql(db, drop_table, ""):
        error("DB: Failed to drop table" + snap_name)
        return FAILURE

    snap_stack_path = TMP_MNTPOINT_DIR + snap_name
    ret_tpl = run_cmd(['rm', '-r', snap_stack_path])
    if validate(ret_tpl, "Remove Snapshot:"+snap_name):
        ret_tpl = run_cmd(['umount', TMP_MNTPOINT_DIR])
        validate(ret_tpl, "Failed umount mntpoint, after snapshot deleted and DB updated.")
        return FAILURE


def do_set_default_snapshot(options):
    """
    Set the File System snapshot to boot from, at next reboot
    Return SUCCESS/FAILURE

    Keyword arguments:
    options -- dict: config options.
    """

    snap_name = options.defsnap
    snap_id = get_snap_id(snap_name)
    if snap_id == None:
        return FAILURE

    ret_tpl = run_cmd(['btrfs', 'subvolume', 'set-default', snap_id, '/'])
    if validate(ret_tpl, "Set Default Snapshot:"+snap_name, True):
        return FAILURE

    info("Next reboot will boot from: "+snap_name)
    return SUCCESS


