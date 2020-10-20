# syntax=docker/dockerfile:1.1-experimental
# SPDX-License-Identifier: Apache-2.0
# Copyright 2020 Authors of Cilium

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.11@sha256:9a839e63dad54c3a6d1834e29692c8492d93f90c59c978c1ed79109ea4fb9a54

FROM ${ALPINE_BASE_IMAGE} as builder
LABEL maintainer="maintainer@cilium.io"

COPY . /checkpatch

RUN for i in /checkpatch/fixes/*.diff; do \
    patch -p1 /checkpatch/checkpatch.pl < "$i"; \
    done

RUN apk add --no-cache bash curl git jq perl

ENTRYPOINT ["/checkpatch/checkpatch.sh"]
