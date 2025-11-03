# syntax=docker/dockerfile:1.1-experimental@sha256:de85b2f3a3e8a2f7fe48e8e84a65f6fdd5cd5183afa6412fff9caa6871649c44
# SPDX-License-Identifier: Apache-2.0
# Copyright Authors of Cilium

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.22.2@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412

FROM ${ALPINE_BASE_IMAGE} as builder
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
