# syntax=docker/dockerfile:1.1-experimental
# SPDX-License-Identifier: Apache-2.0
# Copyright 2020 Authors of Cilium

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.15@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300

FROM ${ALPINE_BASE_IMAGE} as builder
LABEL maintainer="maintainer@cilium.io"

COPY . /checkpatch

RUN apk add --no-cache bash curl git jq moreutils patch perl

RUN for i in /checkpatch/fixes/*.diff; do \
    patch -p1 /checkpatch/checkpatch.pl < "$i"; \
    done

ENTRYPOINT ["/checkpatch/checkpatch.sh"]
