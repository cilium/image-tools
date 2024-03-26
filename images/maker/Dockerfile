# syntax=docker/dockerfile:1.1-experimental

# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG DOCKER_IMAGE=docker.io/library/docker:19.03.15-dind@sha256:c85365ad08c7f6e02ac962a8759c4a5b8512ea5c294d3bb9ed25fca52e9e22e5
ARG CRANE_IMAGE=gcr.io/go-containerregistry/crane:latest@sha256:88335131ccc1f0687226245f68b0b328864026bc6504e97f4e1c130b5c766420
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.18.0@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11
ARG GOLANG_IMAGE=docker.io/library/golang:1.20.1@sha256:52921e63cc544c79c111db1d8461d8ab9070992d9c636e1573176642690c14b5

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
