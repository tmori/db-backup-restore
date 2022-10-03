#!/bin/bash

source env/env.bash

function assert_installed()
{
    cmd=${1}
    which ${cmd} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "ERROR: Not installed ${cmd}"
        exit 1
    fi
}

function assert_file_exist()
{
    filepath=${1}
    if [ -f ${filepath} ]
    then
        :
    else
        echo "ERROR: Not found ${filepath}"
        exit 1
    fi
}
function assert_dir_exist()
{
    filepath=${1}
    if [ -d ${filepath} ]
    then
        :
    else
        echo "ERROR: Not found ${filepath}"
        exit 1
    fi
}

function assert_file_not_exist()
{
    filepath=${1}
    if [ -f ${filepath} ]
    then
        echo "ERROR: Already exists ${filepath}"
        exit 1
    fi
}

export IS_ZIP_FILE="FALSE"
function is_zip_file()
{
    filepath=${1}
    file ${filepath} | grep "gzip compressed data" > /dev/null
    if [ $? -eq 0 ]
    then
        IS_ZIP_FILE="TRUE"
    else
        IS_ZIP_FILE="FALSE"
    fi
}
