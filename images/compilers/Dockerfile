# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG UBUNTU_IMAGE=docker.io/library/ubuntu:20.04@sha256:8bce67040cd0ae39e0beb55bcb976a824d9966d2ac8d2e4bf6119b45505cee64
ARG TESTER_IMAGE=docker.io/cilium/image-tester:70724309b859786e0a347605e407c5261f316eb0@sha256:89cc1f577d995021387871d3dbeb771b75ab4d70073d9bcbc42e532792719781

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
COPY /empty /tmp/empty
