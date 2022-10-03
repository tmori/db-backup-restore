#!/bin/bash

function assert_db_exist()
{
    dbname=${1}
    export PGPASSWORD=${PSQL_DB_PGPASSWORD}
    psql -p ${PSQL_DB_PORT} -h ${PSQL_DB_HOST} -U ${PSQL_DB_USERNAME} -d ${dbname} -c '\l' > /dev/null
    if [ $? -ne 0 ]
    then
        export PGPASSWORD=
        echo "ERROR: Not found DB: ${dbname}"
        exit 1
    fi
    export PGPASSWORD=
}

function assert_db_not_exist()
{
    dbname=${1}
    export PGPASSWORD=${PSQL_DB_PGPASSWORD}
    psql -p ${PSQL_DB_PORT} -h ${PSQL_DB_HOST} -U ${PSQL_DB_USERNAME} -d ${dbname} -c '\l' > /dev/null
    if [ $? -eq 0 ]
    then
        export PGPASSWORD=
        echo "ERROR: Already exists DB: ${dbname}"
        exit 1
    fi
    export PGPASSWORD=
}

function db_backup()
{
    dbname=${1}
    backup_filepath=${2}
    export PGPASSWORD=${PSQL_DB_PGPASSWORD}
    pg_dump -p ${PSQL_DB_PORT} -h ${PSQL_DB_HOST} -U ${PSQL_DB_USERNAME} -d ${dbname} > ${backup_filepath}
    if [ $? -ne 0 ]
    then
        export PGPASSWORD=
        echo "pg_dump error"
        exit 1
    fi
    export PGPASSWORD=
}

function db_restore()
{
    dbname=${1}
    backup_filepath=${2}
    export PGPASSWORD=${PSQL_DB_PGPASSWORD}
    psql -p ${PSQL_DB_PORT} -h ${PSQL_DB_HOST} -U ${PSQL_DB_USERNAME} -d ${dbname} -f ${backup_filepath} 2> restore.err > restore.log
    if [ $? -ne 0 ]
    then
        export PGPASSWORD=
        echo "ERROR: psql error"
        exit 1
    fi
    export PGPASSWORD=
}

function db_drop()
{
    dbname=${1}
    export PGPASSWORD=${PSQL_DB_POSTGRES_PGPASSWORD}
    psql -p ${PSQL_DB_PORT} -h ${PSQL_DB_HOST} -U ${PSQL_DB_POSTGRES_USERNAME} -c "DROP DATABASE ${dbname};"
    if [ $? -ne 0 ]
    then
        export PGPASSWORD=
        echo "ERROR: psql error"
        exit 1
    fi
    export PGPASSWORD=
}

function db_create()
{
    dbname=${1}
    export PGPASSWORD=${PSQL_DB_POSTGRES_PGPASSWORD}
    psql -p ${PSQL_DB_PORT} -h ${PSQL_DB_HOST} -U ${PSQL_DB_POSTGRES_USERNAME} -c "CREATE DATABASE ${dbname};"
    if [ $? -ne 0 ]
    then
        export PGPASSWORD=
        echo "ERROR: psql create dabase error"
        exit 1
    fi
    psql -p ${PSQL_DB_PORT} -h ${PSQL_DB_HOST} -U ${PSQL_DB_POSTGRES_USERNAME} -c "GRANT ALL PRIVILEGES ON DATABASE ${dbname} to ${PSQL_DB_USERNAME};"
    if [ $? -ne 0 ]
    then
        export PGPASSWORD=
        echo "ERROR: psql grant all privileges on database error"
        exit 1
    fi
    export PGPASSWORD=
}
