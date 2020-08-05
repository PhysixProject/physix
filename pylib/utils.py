#!/usr/bin/python3

import db
from definitions import *

import os
import sys
import pwd
import json
import sqlite3
import tarfile
import logging
import datetime
import subprocess
from signal import signal, SIGINT
from optparse import OptionParser

FAILURE = 1
SUCCESS = 0

def info(msg):
    """write info message to log"""
    print("\033[0;33;48m [INFO] \033[0m " + msg)
    logging.info(msg)


def error(msg):
    """write error message to log"""
    msg = "\033[0;31;48m [ERROR] \033[0m " + msg
    print(msg)
    logging.error(msg)


# \e[92m[OK]\e[0m
def ok(msg):
    """write success message to log"""
    msg = "\033[0;32;48m [OK] \033[0m   " + msg
    print(msg)
    logging.info(msg)


def date():
    """Retrun Data-Time: Month/Day/Year-Hour:Minute:Sec"""
    date_time = datetime.datetime.now()
    return str(date_time.strftime("%m/%d/%y-%Hh:%Mm:%Ss"))


def validate(rtn_tpl, msg, report=False):
    """Log appropriate message based on return code"""
    rcode = int(rtn_tpl[0])
    if rcode == SUCCESS:
        if report == True:
            ok(msg)
        return SUCCESS

    error(msg)
    error("RTN:"+str(rtn_tpl[0]))
    error("stdout:"+str(rtn_tpl[1]))
    error("stderr:"+str(rtn_tpl[2]))
    return FAILURE


def get_curr_commit_id():
    """Return commit id of git repo"""
    ret_tpl = run_cmd(['git', 'log', '--oneline'])
    if validate(ret_tpl, "git log --oneline"):
        return None

    output = ret_tpl[1]
    lst = output.split(' ')
    if len(lst) < 1:
        return None
    return str(lst[0])


def root_fs_type():
    """
        Return string: File System type of device mounted at /
        Return FAILURE (1) on error
    """

    ret_tpl = run_cmd(['lsblk', '-o', 'MOUNTPOINT,FSTYPE'])
    if validate(ret_tpl, "Determine root FS type"):
        return FAILURE
    std_out = ret_tpl[1]

    for line in std_out.split('\n'):
        split_line = line.split(' ')
        result = list(filter(lambda x: x != "", split_line))
        if len(result) != 2:
            continue
        if result[0] == '/':
            return result[1]


def root_lvm_path():
    """return path of lvm volume currently mounted as root"""
    ret_tpl = run_cmd(['lsblk', '-r', '-o', 'MOUNTPOINT,PATH'])
    if validate(ret_tpl, "lsblk -r -o MOUNTPOINT,PATH"):
        return None
    std_out = ret_tpl[1]

    parsed_lst = std_out.split('\n')
    for line in parsed_lst:
        slst = line.split(' ')
        if len(slst) == 2 and slst[0] == '/':
            dev_mapper_root = slst[1]
            return str(dev_mapper_root)
    return None


def get_name_current_stack():
    """Return string name of the currently mounted FS snapshot"""
    if 'btrfs' != root_fs_type():
        return 'STACK_0'

    ret_tpl = run_cmd(['btrfs', 'subvolume', 'show', '/'])
    if validate(ret_tpl, "btrfs subvolume show /"):
        return FAILURE
    std_out = ret_tpl[1]

    parsed_lst = std_out.split('\n')
    if parsed_lst[0]:
        return str(parsed_lst[0])
    else:
        return None


def index_already_exists(stack_name):
    """Return boolean: if stack_name (snapshot) already exists"""
    ret_tpl = run_cmd(['btrfs', 'subvolume', 'list', '/'])
    if validate(ret_tpl, "btrfs subvolume list /"):
        return FAILURE
    std_out = ret_tpl[1]

    parsed_lst = std_out.split('\n')
    for entry in parsed_lst:
        datums = entry.split(' ')
        if len(datums) == 9:
            if str(stack_name) == str(datums[8]):
                return True
    return False


def get_snap_id(stack_name):
    """
       Return btrfs snapshot ID
       Returns None if it fails.

       Keyword arguments:
       stack_name -- string
    """
    ret_tpl = run_cmd(['btrfs', 'subvolume', 'list', '/'])
    if validate(ret_tpl, "btrfs subvolume list /"):
        return None
    std_out = ret_tpl[1]

    parsed_lst = std_out.split('\n')
    for entry in parsed_lst:
        datums = entry.split(' ')
        if len(datums) == 9:
            if str(stack_name) == str(datums[8]):
                return str(datums[1])
    return None


def set_build_lock():
    """
        Create a file on FS to indicate the BUILDBOX directory
        should not be modified because another process is most
        likely using it.
        Return SUCCESS/FAILURE
    """
    if not os.path.exists(BUILDLOCK_FILE):
        rtn_tpl = run_cmd(['touch', BUILDLOCK_FILE])
        return validate(rtn_tpl, "buildbox.lock set")
    else:
        error("buildbox.lock Already set.")
        return FAILURE


def unset_build_lock():
    """
    Remove lockfile from File system
    Return SUCCESS/FAILURE
    """
    if os.path.exists(BUILDLOCK_FILE):
        rtn_tpl = run_cmd(['rm', BUILDLOCK_FILE])
        return validate(rtn_tpl, "buildbox.lock removed")
    else:
        error("buildbox.lock not Set.")
        return FAILURE


def load_recipe(cfg):
    """
        Read input recipe as dict

        Keyword arguments:
        cfg -- string: path to config file
    """
    with open(cfg) as file_desc:
        return json.load(file_desc)


def load_physix_config(cfg):
    """
        Read input physix.conf as dict

        Keyword arguments:
        cfg -- string: path to config file
    """
    config = {}
    with open(cfg, "r") as file_desc:
        lines = file_desc.readlines()
        for line in lines:
            line = line.strip().strip().strip("\n")

            if line.startswith('#') or len(line) == 0:
                continue

            lst = line.split("=")
            if len(lst) != 2:
                error("Unexpected Format")

            cfg = str(lst[0])
            val = str(lst[1])
            config[cfg] = val
    return config


def verify_checker(config):
    """
        Read input physix.conf as dict

        Keyword arguments:
        config -- string: path to config file
    """

    filesystem = config['CONF_ROOTPART_FS']
    mkfs = "mkfs." + filesystem
    for tool in ['mkfs.fat', 'mkfs.ext2', mkfs, 'gcc', 'g++', 'make', 'gawk',
                 'bison', 'texi2any', 'parted']:
        ret_tpl = run_cmd(['which', tool])
        if validate(ret_tpl, "Check: "+ tool):
            return FAILURE

    root_dev = config["CONF_ROOT_DEVICE"]
    devlst = os.listdir("/dev")
    dev_count = sum(1 for ln in devlst if root_dev in ln)
    if dev_count > 1:
        msg = "".join(["Found Existing partition(s) on: /dev/", root_dev,
                       "Please remove them and restart this opperation"])
        error(msg)
        return FAILURE

    return SUCCESS


def verify_sfwr_group(group_name, recipe_name):
    """
        Verify the recipe for a software group can be built by
        the operational function it is passed to.
        Return SUCCESS/FAILURE

        Keyword arguments:
        group_name -- string
        recipe_name -- String
    """
    RECIPE = load_recipe(recipe_name)
    buildq = RECIPE['build_queue']
    for i in range(len(buildq)):
        build_id = str(buildq[i])
        element = RECIPE[build_id]
        grp = element['group']
        if grp != group_name:
            return FAILURE
    return SUCCESS


def get_subvol_id(mount_point, stack_name):
    """
        Return ID of snapshot
        Returns: Integer on Success, None on Failure

        Keyword arguments:
        mount_point -- string
        stack_name -- String
    """

    ret_tpl = run_cmd(['btrfs', 'subvolume', 'list', mount_point])
    if validate(ret_tpl, "List subvolumes for mountpoint:" + mount_point):
        return None

    output = ret_tpl[1]
    lst = output.split(' ')
    if len(lst) == 9:
        vol_id = str(lst[1])
        return vol_id
    else:
        error("Unexpected String size.")
        return None


def get_sources_prefix(context):
    """
        Keyword arguments:
        context -- string
    """

    if context == "CHRT":
        return SOURCES_DIR_PATH
    elif context == "NON-CHRT":
        return BUILDROOT_SOURCES_DIR_PATH
    else:
        error("get_sources_prefix(): Unknown context")
        return False


def get_physix_prefix(context):
    """
        Construct system path of physix direcotry
        Return String on success, False on failure.

        Keyword arguments:
        context -- string
    """

    rtn = False
    if context == "CHRT":
        rtn = PHYSIX_DIR
    elif context == "NON-CHRT":
        rtn = BUILDROOT_PHYSIX_DIR
    else:
        error("get_physix_prefix: Unknown context")
    return rtn


def verify_file_md5(fname, rmd5, context):
    """
        Generate md5sum of a fname and compare it against rmd5/
        Returns boolean

        Keyword arguments:
        fname -- string: file name
        rmd5 -- md5sum string 
        context -- string
    """

    rbool = False
    fname_path = get_sources_prefix(context) + fname

    (rtn, output, error) = run_cmd(['md5sum', fname_path])
    if rtn == 0:
        cmpr_md5 = output.split(' ')[0]
        cmpr_md5 = cmpr_md5.replace("b'", "")
        if cmpr_md5 == rmd5:
            ok("MD5 Verified: " + fname + " : " + cmpr_md5)
            rbool = True
        else:
            error("MD5 Verification: " + fname + " : " + cmpr_md5 + ":" + rmd5)

    return rbool


def verify_recipe_md5(recipe, context):
    """
        Traverse through recipe file and verify md5sums of sources

        Keyword arguments:
        recipe -- dict 
        context -- string
    """

    for i in range(len(recipe['build_queue'])):
        element = recipe[str(i)]
        sources = element['physix_sources']

        for url in sources.keys():
            rmd5 = sources[url]
            archv_name = url.split("/")[-1]

            if not verify_file_md5(archv_name, rmd5, context):
                return FAILURE

    return SUCCESS


def demote(user_uid, user_gid):
    def result():
        os.setgid(user_gid)
        os.setuid(user_uid)
    return result


def setup_user_env(user_name, cwd):
    pw_record = pwd.getpwnam(user_name)
    user_name      = pw_record.pw_name
    user_home_dir  = pw_record.pw_dir
    user_uid       = pw_record.pw_uid
    user_gid       = pw_record.pw_gid
    env = os.environ.copy()

    env[ 'HOME'     ]  = user_home_dir
    env[ 'LOGNAME'  ]  = user_name
    env[ 'PWD'      ]  = cwd
    env[ 'USER'     ]  = user_name

    return (env, user_uid, user_gid)


def run_cmd_log_io_as_physix_user(cmd, name, context, cwd):
    """
        Run command and log I/O to log file
        Returns tuple: (int, str, str)

        Keyword arguments:
        cmd -- list:
        name -- string: log name
        context -- string: 'CHRT' or 'NON-CHRT'
        cwd -- 
    """

    env, user_uid, user_gid = setup_user_env('physix', cwd)

    date_time = date()
    date_time = date_time.replace(":", "-").replace(" ", "-").replace("/", "-")
    log_name = date_time + "-" + name
    rtn = FAILURE

    if context == "CHRT":
        log_path = "/opt/admin/logs.physix/" + log_name
    else:
        log_path = "/mnt/physix/opt/admin/logs.physix/" + log_name

    with open(log_path, "w") as file_desc:
        try:
            p = subprocess.run(cmd, preexec_fn=demote(user_uid, user_gid), cwd=cwd, env=env, stdout=file_desc, stderr=file_desc)
            rtn = int(p.returncode)
        except Exception as exc:
            error("[ERROR] Opperation Failed:"+str(exc)),

    return (rtn, "", "")


def run_cmd_log_io_as_root_user(cmd, name, context):
    """
        Run command and log I/O to log file
        Returns tuple: (int, str, str)

        Keyword arguments:
        cmd -- list:
        name -- string: log name
        context -- string: 'CHRT' or 'NON-CHRT'
    """

    # CHECK USER UID

    date_time = date()
    date_time = date_time.replace(":", "-").replace(" ", "-").replace("/", "-")
    log_name = date_time + "-" + name
    rtn = FAILURE

    if context == "CHRT":
        log_path = "/opt/admin/logs.physix/" + log_name
    else:
        log_path = "/mnt/physix/opt/admin/logs.physix/" + log_name

    with open(log_path, "w") as file_desc:
        try:
            p = subprocess.run(cmd, stdout=file_desc, stderr=file_desc)
            rtn = int(p.returncode)
        except Exception as exc:
            error("[ERROR] Opperation Failed:"+str(exc)),

    return (rtn, "", "")


def run_cmd(cmd):
    """
        Run command return captured I/O
        Returns tuple (return_code, stdout, stdin)

        Keyword arguments:
        cmd -- list: command to run
    """

    out = ''
    err = ''
    try:
        p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        rtn = int(p.returncode)
        out = str(p.stdout.decode('utf-8'))
        err = str(p.stderr.decode('utf-8'))
    except Exception as exc:
        error("[Exceotion] Opperation Failed:\n "+str(exc))

    rtn = (int(rtn), str(out), str(err))
    #info("Returning:" + str(rtn))
    return rtn


def run_cmd_live(cmd):
    """ run commmand, don't capture output  """
    try:
        proc = subprocess.run(cmd)
        rtn = int(proc.returncode)
    except Exception as exc:
        error("[ERROR] run_cmd Execption."+str(exc)),
    return (rtn, "", "")


def top_most_dir(archive_path):
    """ Return name of directory encapsolated in the tar archive """
    archive_path = archive_path.strip().strip("\n")
    if not os.path.exists(archive_path):
        error("Expected path does not exist: " + archive_path)
    with tarfile.open(archive_path, mode='r') as archive:
        tmd = str(os.path.commonprefix(archive.getnames()))
        ''' Sometimes a path is returned '''
        tmd_lst = tmd.split("/")
        name_lst = list(filter(len, tmd_lst))
        return str(name_lst[0])


def name_is_valid(name):
    if '-' in name:
        error("Snapshot Name can not contain '-' character")
        return False

    if name[0].isdigit():
        error("Snatpshot Name can not start with numerical digit")
        return False
    return True


def refresh_build_box(context):
    """ Remove and Re-create BUILDBOX """

    prefix = get_sources_prefix(context)
    bb_path = prefix + "BUILDBOX"

    if os.path.exists(bb_path):
        ret_tpl = run_cmd(['rm', '-r', bb_path])
        validate(ret_tpl, '')

        os.mkdir(bb_path, 0o700)
        ret_tpl = run_cmd(['mkdir', '-p', bb_path])
        validate(ret_tpl, "mkdir bb_path: " + bb_path)

        ret_tpl = run_cmd(['chown', 'physix:root', bb_path])
        validate(ret_tpl, "chown physix " + bb_path)
    else:
        os.mkdir(bb_path, 0o700)
        ret_tpl = run_cmd(['chown', 'physix:root', bb_path])
        validate(ret_tpl, "chown physix " + bb_path)

    return True


def verify_build_bounderies(options, RECIPE):
    start = 0
    stop = 0

    buildq = RECIPE['build_queue']
    if options.start_number:
        start = int(options.start_number)
    else:
        start = 0

    if options.stop_number:
        stop = int(options.stop_number)
    else:
        stop = len(buildq)

    if not (start >= 0 and start <= len(buildq)):
        error("Invalid start number")
        return (None, None)
    if not (stop >= start and stop <= len(buildq)):
        error("Invalid stop number")
        return (None, None)

    return (start, stop)


def unpack(element, context):
    """ Move extract archives, and patches to BUILDBOX dir """
    dir_list = []
    archive_list = []

    if element['archives'] == []:
        return []

    # Archives are stored in 1 or 2 paths, depending on
    # whether executed in chrooted or non-chrooted context
    src_path = get_sources_prefix(context)
    bb_path = src_path + "BUILDBOX/"

    if not os.path.exists(bb_path):
        error("Build Env Nnt Found")
        return FAILURE

    for archive in element["archives"]:
        info('Unpacking:'+archive)
        archive_path = bb_path + archive

        if not os.path.exists(archive_path):
            error("Archive not found in BUILDBOX: "+archive_path)
            return FAILURE

        if ('tar' in archive) or ('tgz' in archive):
            ret_tpl = run_cmd(['tar', 'xf', archive_path, '-C', bb_path])
            if validate(ret_tpl, 'unpack to buildbox :' + archive_path):
                error("Tar Failure")
                return FAILURE
        elif 'bz2' in archive:
            ''' Not a tar arvhive, but a straight bz2 compressed file '''
            ret_tpl = run_cmd(['bunzip2', '-dk', archive_path])
            if validate(ret_tpl, 'bunzip2: ' + archive_path):
                error("unzip failure")
                return FAILURE

    # ASSIGN OWNERSHIP TO 'physix'
    ret_tpl = run_cmd(['chown', '--recursive', 'physix:physix', bb_path])
    if validate(ret_tpl, "chown bbox"):
        error("Failed to chown BUILDBOX")
        return FAILURE

    return SUCCESS

