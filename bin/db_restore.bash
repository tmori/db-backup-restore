#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Usage: $0 <dbname> <backup-filepath>"
    exit 1
fi

source env/env.bash
source utils/check-utils.bash

DBNAME=${1}
BACKUP_FILEPATH=${2}

assert_installed file
assert_installed gunzip
assert_installed psql
assert_file_exist ${BACKUP_FILEPATH}
assert_db_exist ${DBNAME}

echo "Now restoring(text file):${BACKUP_FILEPATH}"
db_restore ${DBNAME} ${BACKUP_FILEPATH}

ERR_LOG=`stat ./restore.err | grep Size| awk '{print $2}'`
if [ ${ERR_LOG} -ne 0 ]
then
    echo "ERROR: psql restore error: see ./restore.err"
    exit 1
fi

echo "OK"
exit 0
