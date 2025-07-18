# syntax=docker/dockerfile:1.17@sha256:38387523653efa0039f8e1c89bb74a30504e76ee9f565e25c9a09841f9427b05

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG DOCKER_IMAGE=docker.io/library/docker:28.3.1-dind@sha256:4dd2f7e405b1a10fda628f22cd466be1e3be2bcfc46db653ab620e02eeed5794
ARG CRANE_IMAGE=gcr.io/go-containerregistry/crane:latest@sha256:13952b31a107e8bc4e4c170b0097edb708cd468486a28fc20bbf0d49f71c74e1
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715
ARG GOLANG_IMAGE=docker.io/library/golang:1.24.5@sha256:a9219eb99cd2951b042985dbec09d508b3ddc20c4da52a3a55b275b3779e4a05

FROM ${DOCKER_IMAGE} AS docker-dist
FROM ${CRANE_IMAGE} AS crane-dist

FROM ${GOLANG_IMAGE} AS go-builder

# hadolint ignore=SC2215
RUN --mount=type=bind,readwrite,target=/src --mount=target=/root/.cache,type=cache --mount=target=/go/pkg/mod,type=cache \
    /src/build-go-deps.sh

FROM ${ALPINE_BASE_IMAGE} AS builder
ARG TARGETARCH

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

ARG HADOLINT_VERSION=2.12.0

RUN case "${TARGETARCH}" in \
    'amd64') export ARCH='x86_64' ;; \
    'arm64') export ARCH='arm64' ;; \
    esac && \
    curl --fail --show-error --silent --location \
    https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-${ARCH} \
    --output /out/usr/local/bin/hadolint \
    && chmod +x /out/usr/local/bin/hadolint

RUN mkdir -p /out/etc/docker/cli-plugins \
    && echo '{ "experimental": "enabled", "credsStore" : "env" }' > /out/etc/docker/config.json \
    && ln -fs /usr/local/bin/docker-buildx /out/etc/docker/cli-plugins

FROM scratch
ENV DOCKER_CONFIG=/etc/docker
# when `buldx create` is used, by default it stores configs of builder isntances in
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
