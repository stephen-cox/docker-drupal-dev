#!/bin/bash

# Declare db module
MODULES[db]='Database functions'

# Declare db module commands
declare -A db_COMMANDS
db_COMMANDS[cli]='Run database CLI'
db_COMMANDS[create]='Create an empty database for every SQL file in the database directory'
db_COMMANDS[dump]='Dump databases to database directory'
db_COMMANDS[import]='Import all the databases in the database directory'


# MySQL authentication details
MYSQL_USER="root"
MYSQL_HOST=127.0.0.1
export MYSQL_PWD="root"

##
# Check MySQL client and database - helper function
##
function _check_mysql() {

    # Check if mysql client installed
    command -v mysql >/dev/null 2>&1 || { echo >&2 "Error: mysql client not installed."; exit 2; }
    command -v mysqldump >/dev/null 2>&1 || { echo >&2 "Error: mysqldump not installed."; exit 2; }

    # Check if MySQL server listening on 127.0.0.1 port 3306
    nc -z 127.0.0.1 3306 || { echo >&2 "Error: Unable to connect to MySQL server"; exit 3; }
}

##
# Get database dump directory - helper function
##
function _get_dump_dir() {

    # Determine dump directory
    ROOT_DIR=`git rev-parse --show-toplevel`
    BACKUP_DIR="${ROOT_DIR}/databases"
    [ -d "${BACKUP_DIR}" ] || { echo >&2 "Error: Unable to determine databases directory"; exit 4; }

    echo "${BACKUP_DIR}"
}

##
# Open MySQL cli
##
function db_cli() {
    echo "Running DB CLI"

    _check_mysql
    mysql -u $MYSQL_USER  -h $MYSQL_HOST
}

##
# Create databases
##
function db_create() {
    echo "Creating databases"

    _check_mysql
    DB_DIR=$(_get_dump_dir)

    for FILE in ${DB_DIR}/*.sql; do
        NAME=${FILE##*/}
        DB=${NAME%.sql}
        if ! mysql -u $MYSQL_USER  -h $MYSQL_HOST -e "USE ${DB}" >/dev/null 2>&1; then
            echo "Creating ${DB}"
            mysql -u $MYSQL_USER  -h $MYSQL_HOST -e "CREATE DATABASE ${DB}"
        else
            echo "Database ${DB} exists"
        fi
    done
}

##
# Dump databases
##
function db_dump() {
    echo "Dumping databases"

    _check_mysql
    DB_DIR=$(_get_dump_dir)

    confirm "You are about to overwrite all databases in the databases directory"

    DATABASES=`mysql -u $MYSQL_USER -h $MYSQL_HOST -e "SHOW DATABASES;" | grep -Ev "(Database|sql|information_schema|performance_schema)"`
    for DB in $DATABASES; do
      echo "Dumping ${DB} to ${DB_DIR}/${DB}.sql"
      mysqldump --force -u $MYSQL_USER  -h $MYSQL_HOST --quick --single-transaction --no-create-db $DB > "${DB_DIR}/${DB}.sql"
    done
}

##
# Import databases
##
function db_import() {
    echo "Importing databases"

    _check_mysql
    DB_DIR=$(_get_dump_dir)

    for FILE in ${DB_DIR}/*.sql; do
        NAME=${FILE##*/}
        DB=${NAME%.sql}
        if ! mysql -u $MYSQL_USER  -h $MYSQL_HOST -e "USE ${DB}" >/dev/null 2>&1; then
            echo "Creating ${DB}"
            mysql -u $MYSQL_USER  -h $MYSQL_HOST -e "CREATE DATABASE ${DB}"
        fi
        echo "Importing ${DB}"
        mysql -u $MYSQL_USER  -h $MYSQL_HOST $DB < $FILE
    done
}
