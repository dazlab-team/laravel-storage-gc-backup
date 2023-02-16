#!/bin/sh

set -e

if [ "${GCS_KEY_FILE_PATH}" = "" ]; then
  GCS_KEY_FILE_PATH=/gc-service-account.json
fi

if [ ! -f "${GCS_KEY_FILE_PATH}" ]; then
  echo "${GCS_KEY_FILE_PATH} must point to a file"
  exit 1
fi

if [ -z "${GCS_BUCKET}" ]; then
  echo "You need to set the GCS_BUCKET environment variable."
  exit 1
fi

if [ -z "${CRON_EXPR}" ]; then
  CRON_EXPR='0 0 * * *'
fi

echo "Schedule backup to ${GCS_BUCKET}: ${CRON_EXPR}"
echo "${CRON_EXPR} cd /laravel-storage-gc-backup && ./run.sh" > crontab.txt
/usr/bin/crontab crontab.txt

# start cron
/usr/sbin/crond -f -l 8
