FROM docker:stable

ARG TINI_VERSION='0.18.0'
ARG GLIBC_VERSION='2.29-r0'

ENV BACKUP_TIME='03:00:00'

RUN apk add --update \
        # for `trap '...' ERR`
        bash \
        # Install `date` that supports `-d 'tomorrow'`
        coreutils \
    # Resilio dependencies
    && apk --no-cache add ca-certificates \
        && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
        && mkdir -p /tmp/glibc && cd /tmp/glibc \
        && wget -q -O glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
        && apk add glibc.apk \
        && cd /tmp && rm -rf /tmp/glibc \
    && rm -rf /var/cache/apk/*

COPY *.bash /

RUN mkdir -p /etc/resilio/storage
RUN mkdir -p /tmp/resilio && cd /tmp/resilio \
    && wget -q -O resilio.tar.gz https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz \
    && tar -xf resilio.tar.gz \
    && mv rslsync /usr/local/bin/ \
    && cd /tmp && rm -rf /tmp/resilio
COPY resilio.conf.template /etc/

ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static /tini
RUN chmod +x /tini

RUN mkdir -p /volumes
RUN mkdir -p /backup/archives

VOLUME ["/backup/archives"]

ENTRYPOINT ["/tini", "--", "/entrypoint.bash"]
CMD []
