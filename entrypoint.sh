#!/bin/sh

set -e

if [ "${GCS_KEY_FILE_PATH}" = "" ]; then
  echo "You need to set the GCS_KEY_FILE_PATH	environment variable."
  exit 1
fi

if [ ! -f "${GCS_KEY_FILE_PATH}" ]; then
  echo "${GCS_KEY_FILE_PATH} must point to a file"
  exit 1
fi

if [ "${GCS_BUCKET}" = "" ]; then
  echo "You need to set the GCS_BUCKET environment variable."
  exit 1
fi

echo "Schedule backup to ${GCS_BUCKET}: ${CRON_EXPR}"

# start cron
/usr/sbin/crond -f -l 8
