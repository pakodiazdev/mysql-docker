#!/bin/bash

set -e

if [ -n "$MYSQL_EXTRA_DATABASES" ]; then
  echo "📦 Bases de datos adicionales a crear: $MYSQL_EXTRA_DATABASES"

  IFS=',' read -ra DBS <<< "$MYSQL_EXTRA_DATABASES"
  for db in "${DBS[@]}"; do
    db_trimmed=$(echo "$db" | xargs)
    if [ -n "$db_trimmed" ]; then
      echo "  ➕ Creando base: $db_trimmed"
      mysql -uroot -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`$db_trimmed\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        GRANT ALL PRIVILEGES ON \`$db_trimmed\`.* TO '$MYSQL_USER'@'%';
EOSQL
    fi
  done
fi
