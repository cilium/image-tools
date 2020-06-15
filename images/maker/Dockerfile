# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG DOCKER_IMAGE=docker:19.03.8-dind@sha256:841b5eb000551dc3c30a46386ab4bfed5839ec9592c88e961236b25194ce88b9
ARG CRANE_IMAGE=gcr.io/go-containerregistry/crane:latest@sha256:88335131ccc1f0687226245f68b0b328864026bc6504e97f4e1c130b5c766420
ARG ALPINE_BASE_IMAGE=alpine:3.11@sha256:9a839e63dad54c3a6d1834e29692c8492d93f90c59c978c1ed79109ea4fb9a54
ARG GOLANG_IMAGE=golang:1.14.3@sha256:1e36f8e9ac49d5ee6d72e969382a698614551a59f4533d5d61590e3deeb543a7

FROM ${DOCKER_IMAGE} as docker-dist
FROM ${CRANE_IMAGE} as crane-dist

FROM ${GOLANG_IMAGE} as go-builder

COPY build-credentials-helper.sh /tmp/build-credentials-helper.sh
RUN /tmp/build-credentials-helper.sh

FROM ${ALPINE_BASE_IMAGE} as builder

RUN apk add --no-cache \
    curl \
    && true

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/

RUN apk add --initdb --no-cache --root /out \
    alpine-baselayout \
    bash \
    ca-certificates \
    coreutils \
    git \
    make \
    shellcheck \
    && true

COPY --from=docker-dist /usr/local/bin /out/usr/local/bin
COPY --from=crane-dist /ko-app/crane /out/usr/local/bin/crane
COPY --from=go-builder /src/docker-credential-env /out/usr/local/bin/docker-credential-env

ARG HADOLINT_VERSION=1.17.6

RUN curl --fail --show-error --silent --location \
      https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 \
    --output /out/usr/local/bin/hadolint \
    && chmod +x /out/usr/local/bin/hadolint

ARG BUILDX_VERSION=0.4.1

RUN curl --fail --show-error --silent --location \
      https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-amd64 \
    --output /out/usr/local/bin/docker-buildx \
    && chmod +x /out/usr/local/bin/docker-buildx

RUN mkdir -p /out/etc/docker/cli-plugins \
    && echo '{ "experimental": "enabled", "credsStore" : "env" }' > /out/etc/docker/config.json \
    && ln -fs /usr/local/bin/docker-buildx /out/etc/docker/cli-plugins

# when `buldx create` is used, it stores names of builders in $DOCKER_CONFIG/buildx,
# which works as long as home directory is persisted, across invocations, however
# when invoked from inside a container the $DOCKER_CONFIG/buildx directory is not
# persisten unless it's mounted from the host
# normally, one could use `docker run -v "${buildx_dir}:/etc/docker/buildx" ...`,
# however it's not currently possible to specifiy a volume in GitHub Actions config,
# hence the workspace path is used
# in turns, this means that there has to be `.buildx` at the top of the workspace
# (see https://github.com/docker/buildx/issues/308)
RUN ln -s -f /github/workspace/.buildx /out/etc/docker/buildx

FROM scratch
ENV DOCKER_CONFIG=/etc/docker
ENV MAKER_CONTAINER=true
COPY --from=builder /out /
