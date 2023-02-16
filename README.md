# laravel-storage-gc-backup

A Docker image for periodical backups of Laravel's `storage/app` folder to Google Cloud Storage.

## Usage

### Kubernetes Cluster

1. Create Kubernetes secret containing the GC service account JSON key:

```bash
kubectl create secret generic laravel-storage-gc-backup \
 --from-file=gc-service-account.json=/path/to/keyfile.json
```

2. Add a new sidecar container to the existing Laravel image deployment:

```yaml
  containers:
    - name: laravel-storage-gc-backup
      image: dazlabteam/laravel-storage-gc-backup
      imagePullPolicy: Always
      env:
        - name: GCS_BUCKET
          value: <GC bucket name>
      volumeMounts:
        - name: gc-service-account
          readOnly: true
          mountPath: /gc-service-account.json
          subPath: gc-service-account.json
  volumes:
    - name: gc-service-account
      secret:
        secretName: laravel-storage-gc-backup
```

By default, it will run every day at 00:00. To change this, specify `CRON_EXPR` env variable:

```yaml
  image: dazlabteam/laravel-storage-gc-backup
  env:
    - name: CRON_EXPR
      value: 0 1 * * *
```

#### Backup path and prefix

The two variables can be specified for setting the custom storage path and a custom prefix for a resulting backup
archive:

```yaml
  image: dazlabteam/laravel-storage-gc-backup
  env:
    - name: BACKUP_PATH
      value: /path/to/laravel/storage
    - name: BACKUP_PREFIX
      value: my-custom-archive
```

#### Other options

##### Custom path to GC system account key file

```yaml
  image: dazlabteam/laravel-storage-gc-backup
  env:
    - name: GCS_KEY_FILE_PATH
      value: /my-system-account.json
```

## License

MIT

## Links

- https://hub.docker.com/r/dazlabteam/laravel-storage-gc-backup
- https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/
- https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/
 