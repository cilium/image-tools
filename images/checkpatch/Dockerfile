# syntax=docker/dockerfile:1.1-experimental@sha256:de85b2f3a3e8a2f7fe48e8e84a65f6fdd5cd5183afa6412fff9caa6871649c44
# SPDX-License-Identifier: Apache-2.0
# Copyright 2020 Authors of Cilium

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.20.3@sha256:1e42bbe2508154c9126d48c2b8a75420c3544343bf86fd041fb7527e017a4b4a

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
