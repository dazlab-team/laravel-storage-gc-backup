FROM google/cloud-sdk:alpine
ENV CRON_EXPR='0 0 * * *'
ENV GCS_KEY_FILE_PATH=/gc-service-account.json
WORKDIR /laravel-storage-gc-backup/
ADD ./run.sh run.sh
ADD ./entrypoint.sh entrypoint.sh
RUN chmod +x run.sh entrypoint.sh
RUN echo "$CRON_EXPR cd /laravel-storage-gc-backup && ./run.sh" > crontab.txt
RUN /usr/bin/crontab crontab.txt
CMD ["/laravel-storage-gc-backup/entrypoint.sh"]
