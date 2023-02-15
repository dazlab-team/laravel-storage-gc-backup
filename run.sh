#! /bin/sh

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

if [ "${BACKUP_PATH}" = "" ]; then
  BACKUP_PATH=storage/app
fi

if [ "${BACKUP_PREFIX}" = "" ]; then
  BACKUP_PREFIX=storage-backup
fi

DATE=$(date -u "+%F-%H%M%S")
ARCHIVE_NAME="${BACKUP_PREFIX}-${DATE}.tar.gz"

tar czf "${ARCHIVE_NAME}" "${BACKUP_PATH}"
echo "Uploading ${ARCHIVE_NAME} to ${GCS_BUCKET}"

gcloud auth activate-service-account --key-file="${GCS_KEY_FILE_PATH}"
gsutil cp "${ARCHIVE_NAME}" "gs://$GCS_BUCKET"

rm "${ARCHIVE_NAME}"

echo "Backup done!"
