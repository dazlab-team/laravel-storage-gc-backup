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
    ...
    - name: CRON_EXPR
    value: 0 1 * * *
```

## License

MIT

## Links

- https://hub.docker.com/r/dazlabteam/laravel-storage-gc-backup
- https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/
- https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/
 