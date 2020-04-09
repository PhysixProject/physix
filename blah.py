#!/usr/bin/python3
import os
import sys
import json
import sqlite3
import tarfile
import logging
import datetime
import subprocess

BUILDROOT = "/mnt/physix"
FAILURE = 1
SUCCESS = 0

def validate(rtn_tpl, msg, report=True):
    """ Log appropriate message based on return code"""
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


def info(msg):
    """ write info message to log """
    print("\033[0;33;48m [INFO] \033[0m " + msg)
    logging.info(msg)


def error(msg):
    """ write error message to log """
    msg = "\033[0;31;48m [ERROR] \033[0m " + msg
    print(msg)
    logging.error(msg)


# \e[92m[OK]\e[0m
def ok(msg):
    """ write success message to log """
    msg = "\033[0;32;48m [OK] \033[0m   " + msg
    print(msg)
    logging.info(msg)


def run_cmd(cmd):
    """ Run command, return caputured I/O Streams """
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


def get_db_connection(chroot=''):
    ''' Return db connection object 
        Return None on error '''

    db_path = '/opt/DB.physix'
    conn = None

    try:
        conn = sqlite3.connect(db_path)
    except Exception as e:
        error(str(e))
        return None
    return conn


def get_name_current_stack():
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



print(index_already_exists("STACK_0"))







