# syntax=docker/dockerfile:1.1-experimental@sha256:de85b2f3a3e8a2f7fe48e8e84a65f6fdd5cd5183afa6412fff9caa6871649c44
# SPDX-License-Identifier: Apache-2.0
# Copyright Authors of Cilium

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.24.3@sha256:b3413572228e34bd1c9245f5565e6cd127005655e8a7899aef33d8e83255c9e6

FROM ${ALPINE_BASE_IMAGE} AS builder
LABEL maintainer="maintainer@cilium.io"

ARG CHECKPATCH_VERSION="v5.12"

COPY . /checkpatch

RUN apk add --no-cache bash curl git jq moreutils patch perl

RUN \
    curl -sSL --output /checkpatch/checkpatch.pl \
        "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/checkpatch.pl?h=${CHECKPATCH_VERSION}" && \
    chmod a+x /checkpatch/checkpatch.pl && \
    curl -sSL --output /checkpatch/spelling.txt \
        "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/spelling.txt?h=${CHECKPATCH_VERSION}"

RUN for i in /checkpatch/fixes/*.diff; do \
    patch -p1 /checkpatch/checkpatch.pl < "$i"; \
    done

ENTRYPOINT ["/checkpatch/checkpatch.sh"]
