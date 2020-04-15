# Docker Cron Email

One of the way how you can set up cron jobs from docker container. Also with sending emails.

Cron jobs are set up from environment variables, and not copied to the container during build. This allows more flexibility.

You need to set up "CRONJOB" environment variables, there can be multiple of this variables. "CRONJOB1", "CRONJOB2", e.t. They all need to start with "CRONJOB". Cron logs and jobs output can be found in docker logs.

There are branches for Alpine and Debian Buster.


All variables supported by the container:

```bash
CRONJOB1=* * * * * /some_script.sh
CRONJOB2=* * * * * /some_other_script.sh
CRON_MAIL_USER=cron@example.com
CRON_MAIL_PASSWORD=email_password
SMTP_HOST=smtp.example.com:25
CRON_MAILTO=user@example.com
TZ=UTC
```

You can omit variables needed for email. Don't forget timezone variable, docker container inherits time from host machine, but not timezome.
