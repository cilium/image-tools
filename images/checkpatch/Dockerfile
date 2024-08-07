# syntax=docker/dockerfile:1.1-experimental
# SPDX-License-Identifier: Apache-2.0
# Copyright 2020 Authors of Cilium

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.20.2@sha256:0a4eaa0eecf5f8c050e5bba433f58c052be7587ee8af3e8b3910ef9ab5fbe9f5

FROM ${ALPINE_BASE_IMAGE} as builder
LABEL maintainer="maintainer@cilium.io"

ENV CHECKPATCH_VERSION v5.12

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
