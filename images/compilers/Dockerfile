# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG UBUNTU_IMAGE=docker.io/library/ubuntu:20.04@sha256:8bce67040cd0ae39e0beb55bcb976a824d9966d2ac8d2e4bf6119b45505cee64
ARG TESTER_IMAGE=quay.io/cilium/image-tester:2f8033eaf1c3e64b991e0ed44a570052778c55c7@sha256:f50a01c725e0183766b7e0c8fdff8b492d551bd5314daaa496106f2fde98a285

FROM ${UBUNTU_IMAGE} as builder

COPY install-deps.sh /tmp/install-deps.sh
RUN /tmp/install-deps.sh

COPY install-bazel.sh /tmp/install-bazel.sh
RUN /tmp/install-bazel.sh

FROM ${TESTER_IMAGE} as test
COPY --from=builder / /
COPY test /test
RUN /test/bin/cst

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=builder / /
