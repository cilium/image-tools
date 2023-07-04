# syntax=docker/dockerfile:1.1-experimental
# SPDX-License-Identifier: Apache-2.0
# Copyright 2020 Authors of Cilium

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.18.0@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11

FROM ${ALPINE_BASE_IMAGE} as builder
LABEL maintainer="maintainer@cilium.io"

ENV CHECKPATCH_VERSION v5.12

COPY . /checkpatch

RUN apk add --no-cache bash curl git jq moreutils patch perl

RUN \
    curl -sSL --output /checkpatch/checkpatch.pl \
        "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/checkpatch.pl?h=${CHECKPATCH_VERSION}" && \
    chmod u+x /checkpatch/checkpatch.pl && \
    curl -sSL --output /checkpatch/spelling.txt \
        "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/spelling.txt?h=${CHECKPATCH_VERSION}"

RUN for i in /checkpatch/fixes/*.diff; do \
    patch -p1 /checkpatch/checkpatch.pl < "$i"; \
    done

ENTRYPOINT ["/checkpatch/checkpatch.sh"]
