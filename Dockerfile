FROM google/cloud-sdk:alpine
WORKDIR /laravel-storage-gc-backup/
ADD ./run.sh run.sh
ADD ./entrypoint.sh entrypoint.sh
RUN chmod +x run.sh entrypoint.sh
CMD ["/laravel-storage-gc-backup/entrypoint.sh"]
