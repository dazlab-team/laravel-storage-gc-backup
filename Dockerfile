FROM google/cloud-sdk:alpine
WORKDIR /laravel-storage-gc-backup/
ADD ./run.sh /laravel-storage-gc-backup/run.sh
RUN chmod +x /laravel-storage-gc-backup/run.sh
CMD ["/laravel-storage-gc-backup/run.sh"]
