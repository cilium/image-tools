# syntax=docker/dockerfile:1.1-experimental

# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG DOCKER_IMAGE=docker.io/library/docker:26.0.0-dind@sha256:016c45d9e31461802186e8e9aaa394f35e173a8ce913ea7195a672cdc97102f2
ARG CRANE_IMAGE=gcr.io/go-containerregistry/crane:latest@sha256:30621571a135ddef3f371b3efd000cd76c13f81cb9d5513d105e024dcb30a352
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.20.1@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0
ARG GOLANG_IMAGE=docker.io/library/golang:1.22.5@sha256:829eff99a4b2abffe68f6a3847337bf6455d69d17e49ec1a97dac78834754bd6

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
