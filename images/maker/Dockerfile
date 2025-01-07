# syntax=docker/dockerfile:1.1-experimental@sha256:de85b2f3a3e8a2f7fe48e8e84a65f6fdd5cd5183afa6412fff9caa6871649c44

# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG DOCKER_IMAGE=docker.io/library/docker:27.3.1-dind@sha256:25654f4044cf31ea6ca67707a767c2e7773a5266762aeba44e77307f2166ae2d
ARG CRANE_IMAGE=gcr.io/go-containerregistry/crane:latest@sha256:5583664dfe9bb06b3e09ad612c91bd8378653d3ebec2e0b5e3d3d2c046b3b0a5
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.20.4@sha256:780405de0f7cf99f985dd5a4f04dfc5aae71509d89505c1ba48a88d95a0ceb7f
ARG GOLANG_IMAGE=docker.io/library/golang:1.22.8@sha256:0ca97f4ab335f4b284a5b8190980c7cdc21d320d529f2b643e8a8733a69bfb6b

FROM ${DOCKER_IMAGE} as docker-dist
FROM ${CRANE_IMAGE} as crane-dist

FROM ${GOLANG_IMAGE} as go-builder

# hadolint ignore=SC2215
RUN --mount=type=bind,readwrite,target=/src --mount=target=/root/.cache,type=cache --mount=target=/go/pkg/mod,type=cache \
    /src/build-go-deps.sh

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
    jq \
    yq \
    && true

COPY --from=docker-dist /usr/local/bin /out/usr/local/bin
COPY --from=crane-dist /ko-app/crane /out/usr/local/bin/crane
COPY --from=go-builder /out /out

ARG HADOLINT_VERSION=1.17.6

RUN curl --fail --show-error --silent --location \
      https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 \
    --output /out/usr/local/bin/hadolint \
    && chmod +x /out/usr/local/bin/hadolint

RUN mkdir -p /out/etc/docker/cli-plugins \
    && echo '{ "experimental": "enabled", "credsStore" : "env" }' > /out/etc/docker/config.json \
    && ln -fs /usr/local/bin/docker-buildx /out/etc/docker/cli-plugins

FROM scratch
ENV DOCKER_CONFIG=/etc/docker
# when `buldx create` is used, by defualt it stores configs of builder isntances in
# $BUILDX_CONFIG/buildx (or custom path set with $BUILDX_CONFIG);
# default location works as long as home directory is persisted, across invocations,
# but when invoked from inside a container the $DOCKER_CONFIG/buildx directory is not
# persisten unless it's mounted from the host;
# in GitHub Actions it is relatively safe to assume that $PWD/.buildx is where the
# builder instance of a single job need to be stored, which can be achived by using
# relative path here (see also https://github.com/docker/buildx/issues/308)
ENV BUILDX_CONFIG=.buildx
ENV MAKER_CONTAINER=true
COPY --from=builder /out /
