FROM docker:stable

ARG TINI_VERSION='0.18.0'

ENV BACKUP_TIME='03:00:00'

# https://api.slack.com/incoming-webhooks
# ENV SLACK_WEBHOOK='https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX'

RUN apk add --update \
        # for `trap '...' ERR`
        bash \
        # Install `date` that supports `-d 'tomorrow'`
        coreutils \
    && rm -rf /var/cache/apk/*

COPY entrypoint.bash /
COPY backup.bash /

ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static /tini
RUN chmod +x /tini

RUN mkdir -p /v
RUN mkdir -p /backup/archives

VOLUME ["/backup"]

ENTRYPOINT ["/tini", "--", "/entrypoint.bash"]
CMD []
