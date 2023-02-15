# laravel-storage-gc-backup

A Docker image for periodical backups of Laravel's `storage/app` folder to Google Cloud Storage.

## Usage

### Run via Docker

```bash
docker run \
 -e GCS_KEY_FILE_PATH=/gc-service-account.json \
 -e GCS_BUCKET=<GC bucket name> \
 --mount type=bind,source=/path/to/keyfile,target=/gc-service-account.json \
 --mount type=bind,source=/path/to/storage,target=/laravel-storage-gc-backup/storage \
 dazlabteam/laravel-storage-gc-backup
```

### Run via Docker Compose

Edit your Docker Compose file, add new `laravel-storage-backup` service:

```yaml
  laravel-storage-backup:
    image: dazlabteam/laravel-storage-gc-backup
    environment:
      GCS_KEY_FILE_PATH: <path to GC service account key file>
      GCS_BUCKET: <GC bucket name>
```

Then run

```bash
docker-compose -f <path to docker compose yaml> run --rm laravel-storage-backup
```

or by specifying env variables via the command line:

```bash
docker-compose -f <path to docker compose yaml> run --rm \
 -e GCS_KEY_FILE_PATH=<path to GC service account key file> \
 -e GCS_BUCKET=<GC bucket name> \
 laravel-storage-backup
```

### Schedule inside Kubernetes Cluster

Create Kubernetes secret containing all the environment variables:

```bash
kubectl create secret generic laravel-storage-gc-backup \
 --from-literal=GCS_KEY_FILE_PATH=<path to GC service account key file> \
 --from-literal=GCS_BUCKET=<GC bucket name>
```

then create CronJob using the cronjob spec file from this repo:

```
kubectl apply -f laravel-storage-gc-backup.cronjob.yaml
```

By default, it will run every day at 00:00. To change this, edit cronjob and specify other schedule:

```
kubectl edit cronjob laravel-storage-gc-backup
```

## License

MIT

## Links

- https://hub.docker.com/r/dazlabteam/laravel-storage-gc-backup
- https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/
- https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/
 