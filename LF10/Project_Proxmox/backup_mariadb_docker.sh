#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="your_mariadb_container"
DB_ROOT_PASSWORD="your_root_password"
BACKUP_ROOT="$HOME/mariadb_backups"
RETENTION_DAYS=14

TIMESTAMP="$(date +%F_%H-%M)"
WORK_DIR="$BACKUP_ROOT/work_$TIMESTAMP"
ARCHIVE_PATH="$BACKUP_ROOT/mariadb_backup_$TIMESTAMP.tar.gz"

mkdir -p "$WORK_DIR/config"

# Dump all databases consistently
docker exec "$CONTAINER_NAME" mariadb-dump \
  -u root \
  -p"$DB_ROOT_PASSWORD" \
  --all-databases \
  --single-transaction \
  --routines \
  --triggers > "$WORK_DIR/all_databases.sql"

# Copy configuration from inside the container
docker cp "$CONTAINER_NAME:/etc/mysql/." "$WORK_DIR/config/"

# Create compressed archive and remove temporary folder
tar -czf "$ARCHIVE_PATH" -C "$BACKUP_ROOT" "work_$TIMESTAMP"
rm -rf "$WORK_DIR"

# Remove archives older than RETENTION_DAYS
find "$BACKUP_ROOT" -name "mariadb_backup_*.tar.gz" -type f -mtime +"$RETENTION_DAYS" -delete
