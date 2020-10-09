ARG COMPOSE_TAG="latest"

FROM linuxserver/docker-compose:amd64-${COMPOSE_TAG} as compose-amd64
FROM linuxserver/docker-compose:arm32v7-${COMPOSE_TAG} as compose-arm32
FROM linuxserver/docker-compose:arm64v8-${COMPOSE_TAG} as compose-arm64

FROM linuxserver/docker-compose:amd64-alpine-${COMPOSE_TAG} as compose-alpine-amd64
FROM linuxserver/docker-compose:arm32v7-alpine-${COMPOSE_TAG} as compose-alpine-arm32
FROM linuxserver/docker-compose:arm64v8-alpine-${COMPOSE_TAG} as compose-alpine-arm64

FROM lsiobase/alpine:3.11 as buildstage

COPY --from=compose-amd64 /usr/local/bin/docker-compose /root-layer/docker-compose/docker-compose_x86_64
COPY --from=compose-amd64 /usr/local/bin/docker /root-layer/docker-compose/docker_x86_64
COPY --from=compose-arm32 /usr/local/bin/docker-compose /root-layer/docker-compose/docker-compose_armv7l
COPY --from=compose-arm32 /usr/local/bin/docker /root-layer/docker-compose/docker_armv7l
COPY --from=compose-arm64 /usr/local/bin/docker-compose /root-layer/docker-compose/docker-compose_aarch64
COPY --from=compose-arm64 /usr/local/bin/docker /root-layer/docker-compose/docker_aarch64

COPY --from=compose-alpine-amd64 /usr/local/bin/docker-compose /root-layer/alpine/docker-compose/docker-compose_x86_64
COPY --from=compose-alpine-amd64 /usr/local/bin/docker /root-layer/alpine/docker-compose/docker_x86_64
COPY --from=compose-alpine-arm32 /usr/local/bin/docker-compose /root-layer/alpine/docker-compose/docker-compose_armv7l
COPY --from=compose-alpine-arm32 /usr/local/bin/docker /root-layer/alpine/docker-compose/docker_armv7l
COPY --from=compose-alpine-arm64 /usr/local/bin/docker-compose /root-layer/alpine/docker-compose/docker-compose_aarch64
COPY --from=compose-alpine-arm64 /usr/local/bin/docker /root-layer/alpine/docker-compose/docker_aarch64
COPY root/ /root-layer/

# runtime stage
FROM scratch

LABEL maintainer="roxedus"

# Add files from buildstage
COPY --from=buildstage /root-layer/ /