#!/bin/bash
echo "Database import script"

# MySQL authentication details
MYSQL_USER="root"
MYSQL_HOST=mysql
export MYSQL_PWD="root"

# Check if mysql client installed
command -v mysql >/dev/null 2>&1 || { echo >&2 "Error: mysql client not installed."; exit 2; }

# Check if MySQL server listening on 127.0.0.1 port 3306
nc -z 127.0.0.1 3306 || { echo >&2 "Error: Unable to connect to MySQL server"; exit 3; }

# Determine dump directory
ROOT_DIR=`git rev-parse --show-toplevel`
DB_DIR="${ROOT_DIR}/databases"
[ -d "${DB_DIR}" ] || { echo >&2 "Error: Unable to determine databases directory"; exit 4; }

# Create databases for every dump
for FILE in ${DB_DIR}/*.sql; do
	NAME=${FILE##*/}
    DB=${NAME%.sql}
    if ! mysql -u $MYSQL_USER  -h $MYSQL_HOST -e "USE ${DB}" >/dev/null 2>&1; then
    	echo "Creating database ${DB}"
    	mysql -u $MYSQL_USER  -h $MYSQL_HOST -e "CREATE DATABASE ${DB}"
	fi
	echo "Importing database ${DB}"
	mysql -u $MYSQL_USER  -h $MYSQL_HOST $DB < $FILE
done
