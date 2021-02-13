#!/usr/bin/python3
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

FAILURE = 1
SUCCESS = 0

from utils import *
from definitions import *

def get_db_connection(context):
    """Return db connection object. Return None on error."""
    db_path = ''
    conn = None

    if context == "CHRT":
        db_path = DB_PATH
    elif context == "NON-CHRT":
        db_path = BUILDROOT_DB_PATH
    else:
        error("get_db_connection(): Unknown context")
        return None 

    try:
        conn = sqlite3.connect(db_path)
    except Exception as e:
        error(str(e))
        return None
    return conn


def list_stack(conn):
    """Read DB.physix stack table and output the entries. 
       Return FAILUE/SUCCESS

       Keyword arguments:
       conn -- sqlite db object
    """

    if os.path.exists('/mnt/physix/opt/admin/physix'):
        context = 'NON-CHRT'
    else:
        context = 'CHRT'

    stack_name = get_name_current_stack(context)

    stack_lst = []
    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM "+stack_name)
        stack_lst = cur.fetchall()
    except Exception as e:
        error(e)
        return FAILURE

    info("stack::"+str(stack_name))
    info("Stack Size: "+str(len(stack_lst)))
    print('{:<6s} {:<20s} {:<10s} {:<10} {:<10s} {:<30s} {:<30s}'.format('key', 'DATE', 'OP', 'COMMIT', 'SNAP', 'PKG', 'SCRIPT' ))
    for i in range(len(stack_lst)-1, -1, -1):
        prim_key = str(stack_lst[i][0])
        date     = str(stack_lst[i][1])
        op       = str(stack_lst[i][2])
        commit   = str(stack_lst[i][3])
        snap     = str(stack_lst[i][4])
        pkg      = str(stack_lst[i][5])
        script   = str(stack_lst[i][6])

        listing = " ".join([prim_key, date, op, snap, pkg, script])
        print('{:<6s} {:<20s} {:<10s} {:<10s} {:<10s} {:<30s} {:<30s}'.format(prim_key, date, op, commit, snap, pkg, script ))
    return SUCCESS


def init_db_tables():
    """Create initial STACK_0 Table and initialize it.
       Returns SUCCESS/FAILURE"""

    if os.path.exists(BUILDROOT_DB_PATH):
        return SUCCESS

    conn = None
    try:
        conn = sqlite3.connect('/mnt/physix/opt/admin/.DB.physix')
    except Exception as e:
        error(str(e))
        return FAILURE

    sql_create_init_stack = """ CREATE TABLE IF NOT EXISTS STACK_0 (
                                    ID integer PRIMARY KEY AUTOINCREMENT,
                                    TIME text NOT NULL,
                                    OP text NOT NULL,
                                    COMMITID text,
                                    SNAPID text,
                                    PKG text,
                                    SCRIPT text); """
    try:
        cur = conn.cursor()
        cur.execute(sql_create_init_stack, "")
        conn.commit()
    except Exception as e:
        error(str(e))
        return FAILURE

    sql = ''' INSERT INTO STACK_0 (TIME,OP,COMMITID,SNAPID,PKG,SCRIPT) VALUES(?,?,?,?,?,?) '''
    init_values = (date(), 'INIT', '', '', '','')
    try:
        cur = conn.cursor()
        cur.execute(sql, init_values)
        conn.commit()
    except Exception as e:
        error(str(e))
        return FAILURE

    return SUCCESS


def exec_sql(conn, sql, data):
    """Executes an SQL query/command

       Keyword arguments:
       conn -- sqlite db object
       sql -- string: sql query/command
       data -- string:data assiciated with the sql string
    """

    try:
        cur = conn.cursor()
        cur.execute(sql, data)
        conn.commit()
    except Exception as e:
        error(str(e))
        return FAILURE
    return SUCCESS


def write_db_stack_entry(context, cmt_id, operation, build_src, pkg_name):
    '''
    Write entry to physix.db

    Keyword arguments:
    context --  STRING
    cmt_id -- STRING
    operation -- STRING
    build_src  -- STRING
    pkg_name -- STRING
    '''

    db = get_db_connection(context)
    if db:
        stack_name = get_name_current_stack(context)
        entry = (date(), operation, cmt_id, str(stack_name), build_src, str(pkg_name))
        sql = "INSERT INTO "+ stack_name + " (TIME,OP,COMMITID,SNAPID,PKG,SCRIPT) VALUES(?,?,?,?,?,?) "
        info("Stack: " + stack_name)
        if exec_sql(db, sql, entry):
            error("DB: Failed to insert entry")
            return FAILURE
        db.close()
    return SUCCESS

