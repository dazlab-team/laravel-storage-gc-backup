#! /bin/sh

set -e

while getopts ":k:b:p:" opt; do
  case ${opt} in
  b)
    GCS_BUCKET=$OPTARG
    ;;
  p)
    BACKUP_PATH=$OPTARG
    ;;
  k)
    GCS_KEY_FILE_PATH=$OPTARG
    ;;
  *)
    echo "Invalid Option: -$OPTARG" 1>&2
    ;;
  esac
done


if [ "${GCS_KEY_FILE_PATH}" = "" ]; then
  GCS_KEY_FILE_PATH=/gc-service-account.json
fi

if [ "${BACKUP_PATH}" = "" ]; then
  BACKUP_PATH=storage/app
fi

if [ "${BACKUP_PREFIX}" = "" ]; then
  BACKUP_PREFIX=laravel-storage-backup
fi

DATE=$(date -u "+%F-%H%M%S")
ARCHIVE_NAME="${BACKUP_PREFIX}-${DATE}.tar.gz"

echo "Backing up ${BACKUP_PATH}"
tar czf "${ARCHIVE_NAME}" ${BACKUP_PATH}
echo "Uploading ${ARCHIVE_NAME} to ${GCS_BUCKET}"

gcloud auth activate-service-account --key-file="${GCS_KEY_FILE_PATH}"
gsutil cp "${ARCHIVE_NAME}" "gs://${GCS_BUCKET}"

rm "${ARCHIVE_NAME}"

echo "Backup done!"
