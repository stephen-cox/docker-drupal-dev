#!/bin/bash
echo "Database dump script"

# Confirm before continuing
echo "Warning: This will overwrite all databases in the databases directory"
read -n 1 -p "Are you sure [Y/N]? " REPLY
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted"
    exit 1
fi

# MySQL authentication details
MYSQL_USER="root"
MYSQL_HOST=127.0.0.1
export MYSQL_PWD="root"

# Check if mysql client installed
command -v mysql >/dev/null 2>&1 || { echo >&2 "Error: mysql client not installed."; exit 2; }
command -v mysqldump >/dev/null 2>&1 || { echo >&2 "Error: mysqldump not installed."; exit 2; }

# Check if MySQL server listening on 127.0.0.1 port 3306
nc -z 127.0.0.1 3306 || { echo >&2 "Error: Unable to connect to MySQL server"; exit 3; }

# Determine dump directory
ROOT_DIR=`git rev-parse --show-toplevel`
BACKUP_DIR="$ROOT_DIR/databases"
[ -d "$BACKUP_DIR" ] || { echo >&2 "Error: Unable to determine databases directory"; exit 4; }

# Dump databases
DATABASES=`mysql -u $MYSQL_USER -h $MYSQL_HOST -e "SHOW DATABASES;" | grep -Ev "(Database|sql|information_schema|performance_schema)"`
for DB in $DATABASES; do
  echo "Dumping $DB to $BACKUP_DIR/$DB.sql"
  mysqldump --force -u $MYSQL_USER  -h $MYSQL_HOST --quick --single-transaction --no-create-db $DB > "$BACKUP_DIR/$DB.sql"
done
