#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Usage: $0 <dbname> <backup-filepath>"
    exit 1
fi

source env/env.bash

DBNAME=${1}
BACKUP_FILEPATH=${2}

source utils/check-utils.bash
source impl/${DB_IMPL_TYPE}/tools.bash

assert_installed file
assert_installed pg_dump
assert_installed gzip
assert_installed gunzip
assert_installed psql
assert_file_not_exist ${BACKUP_FILEPATH}
assert_db_exist ${DBNAME}


echo "Now dumping...."
db_backup ${DBNAME} ${BACKUP_FILEPATH}

echo "CREATED:"
RESULT=`ls -lh  ${BACKUP_FILEPATH}`
echo "'${RESULT}'"
echo "OK"
exit 0
