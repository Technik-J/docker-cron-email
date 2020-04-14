FROM alpine:latest
RUN apk --update add bash tzdata ssmtp
COPY docker-entrypoint.sh /
ENTRYPOINT /docker-entrypoint.sh
