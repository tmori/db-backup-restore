#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Usage: $0 <dbname>"
    exit 1
fi

source env/env.bash

DBNAME=${1}

source utils/check-utils.bash
source impl/${DB_IMPL_TYPE}/tools.bash

assert_installed file
assert_installed psql
assert_db_not_exist ${DBNAME}

echo "Now deleting...."
db_create ${DBNAME}

echo "CREATED: ${DBNAME}"
