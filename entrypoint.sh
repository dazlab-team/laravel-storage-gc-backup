#!/bin/sh

set -e

if [ "${GCS_KEY_FILE_PATH}" = "" ]; then
  GCS_KEY_FILE_PATH=/gc-service-account.json
fi

if [ ! -f "${GCS_KEY_FILE_PATH}" ]; then
  echo "${GCS_KEY_FILE_PATH} must point to a file"
  exit 1
fi

if [ "${BACKUP_PATH}" = "" ]; then
  BACKUP_PATH=storage/app
fi

if [ -z "${GCS_BUCKET}" ]; then
  echo "You need to set the GCS_BUCKET environment variable."
  exit 1
fi

if [ -z "${CRON_EXPR}" ]; then
  CRON_EXPR='0 0 * * *'
fi

echo "Schedule backup of ${BACKUP_PATH} to ${GCS_BUCKET}: ${CRON_EXPR}"
echo "${CRON_EXPR} cd /laravel-storage-gc-backup && ./run.sh -p '${BACKUP_PATH}' -k '${GCS_KEY_FILE_PATH}' -b '${GCS_BUCKET}'" > crontab.txt
/usr/bin/crontab crontab.txt

# start cron
/usr/sbin/crond -f -l 8
