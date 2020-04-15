FROM debian:buster-slim
RUN apt-get update && apt-get install -y cron procps rsyslog msmtp msmtp-mta
COPY rsyslog.conf /etc/rsyslog.conf
COPY docker-entrypoint.sh /
CMD /docker-entrypoint.sh && tail -F /var/log/cron.log
