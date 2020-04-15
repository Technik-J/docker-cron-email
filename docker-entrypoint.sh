#!/bin/bash
set -e

# Finding all cronjobs in ENV variables and removing everything before and the equals sign itself.
CRONJOBS=$(env | grep CRONJOB | sed s/.*=//)
# Split out host and port from SMTP_HOST env variable
IFS=":" read -r SMTP_HOSTNAME SMTP_PORT <<< "$SMTP_HOST"
SMTP_PORT=${SMTP_PORT:-25}

# Writing to crontab file.
cat > "/var/spool/cron/crontabs/root" <<EOF
MAILTO=${CRON_MAILTO}

${CRONJOBS}
# Last line
EOF

chmod 600 /var/spool/cron/crontabs/root

# Writing to msmtp config files.
cat > "/root/.msmtprc" <<EOF
defaults
auth on
tls on
tls_certcheck off

account        cron
host           ${SMTP_HOSTNAME}
port           ${SMTP_PORT}
from           ${CRON_MAIL_USER}
user           ${CRON_MAIL_USER}
password       ${CRON_MAIL_PASSWORD}

account default : cron

EOF

chmod 600 /root/.msmtprc

# Starting rsyslog and crond.
service rsyslog start
cron -L 15
