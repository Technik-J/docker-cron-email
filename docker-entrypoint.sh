#!/bin/bash
set -e

# Finding all cronjobs in ENV variables and removing everything before and the equals sign itself.
CRONJOBS=$(env | grep CRONJOB | sed s/.*=//)
# Split out host and port from SMTP_HOST env variable
IFS=":" read -r SMTP_HOSTNAME SMTP_PORT <<< "$SMTP_HOST"
SMTP_PORT=${SMTP_PORT:-25}

# Writing to crontab file.
cat > "/etc/crontabs/root" <<EOF
MAILTO=${CRON_MAILTO}

${CRONJOBS}
# Last line
EOF

# Writing to ssmtp config files.
cat > "/etc/ssmtp/ssmtp.conf" <<EOF
root=${CRON_MAIL_USER}
AuthUser=${CRON_MAIL_USER}
AuthPass=${CRON_MAIL_PASSWORD}
mailhub=${SMTP_HOSTNAME}:${SMTP_PORT}
hostname=${HOSTNAME}
FromLineOverride=NO

EOF

cat > "/etc/ssmtp/revaliases" <<EOF
root:${CRON_MAIL_USER}:${SMTP_HOSTNAME}:${SMTP_PORT}

EOF

# Starting crond. "-L /proc/1/fd/1" is needed for redirecting cron logs to docker logs.
exec crond -f -l 6 -L /proc/1/fd/1
