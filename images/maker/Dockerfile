# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG DOCKER_IMAGE=docker.io/library/docker:28.4.0-dind@sha256:831644212c5bdd0b3362b5855c87b980ea39a83c9e9adcef2ce03eced99a737a
ARG CRANE_IMAGE=gcr.io/go-containerregistry/crane:latest@sha256:13952b31a107e8bc4e4c170b0097edb708cd468486a28fc20bbf0d49f71c74e1
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1
ARG GOLANG_IMAGE=docker.io/library/golang:1.25.1@sha256:8305f5fa8ea63c7b5bc85bd223ccc62941f852318ebfbd22f53bbd0b358c07e1

FROM ${DOCKER_IMAGE} AS docker-dist
FROM ${CRANE_IMAGE} AS crane-dist

FROM ${GOLANG_IMAGE} AS go-builder

# hadolint ignore=SC2215
RUN --mount=type=bind,readwrite,target=/src \
    --mount=type=cache,target=/root/.cache \
    --mount=type=cache,target=/go/pkg/mod \
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
    "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-${ARCH}" \
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
