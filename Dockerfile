FROM lsiobase/alpine:3.12 as buildstage

# build variables
ARG WEBHOOK_RELEASE

# hadolint ignore=DL3018
RUN \
    echo "**** install build packages ****" && \
    uname -a && \
    apk add --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
        curl \
        g++ \
        gcc \
        git \
        go \
        tar

# hadolint ignore=DL3003,DL4006
RUN \
    echo "**** fetch source code ****" && \
    if [ -z ${WEBHOOK_RELEASE+x} ]; then \
        WEBHOOK_RELEASE=$(curl -sX GET "https://api.github.com/repos/adnanh/webhook/releases/latest" | \
        awk '/tag_name/{print $4;exit}' FS='[""]') \
    ;fi && \
    mkdir -p /tmp/webhook && \
    curl -o /tmp/webhook-src.tar.gz -L \
        "https://github.com/adnanh/webhook/archive/${WEBHOOK_RELEASE}.tar.gz" && \
    tar xf /tmp/webhook-src.tar.gz -C /tmp/webhook --strip-components=1 && \
    echo "**** compile webhook  ****" && \
    cd /tmp/webhook && \
    rm -f go.sum && \
    go get -d && \
    go build -o /app/webhook

FROM lsiobase/alpine:3.12

# set version label
LABEL maintainer="Roxedus"

# copy files from build stage and local files
COPY --from=buildstage /app/webhook /usr/bin/
COPY root/ /
