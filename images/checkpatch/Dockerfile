# syntax=docker/dockerfile:1.1-experimental
# SPDX-License-Identifier: Apache-2.0
# Copyright 2020 Authors of Cilium

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.13.2@sha256:bef0a0cd630e965918669fb69250e91400d9e560a95b3e74b8e78d9d7ff5628e

FROM ${ALPINE_BASE_IMAGE} as builder
LABEL maintainer="maintainer@cilium.io"

COPY . /checkpatch

RUN apk add --no-cache bash curl git jq patch perl

RUN for i in /checkpatch/fixes/*.diff; do \
    patch -p1 /checkpatch/checkpatch.pl < "$i"; \
    done

ENTRYPOINT ["/checkpatch/checkpatch.sh"]
