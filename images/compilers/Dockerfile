# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG UBUNTU_IMAGE=docker.io/library/ubuntu:20.04@sha256:626ffe58f6e7566e00254b638eb7e0f3b11d4da9675088f4781a50ae288f3322
ARG TESTER_IMAGE=quay.io/cilium/image-tester:98852499bdc497763ace7f8d041ee09676a1d989@sha256:36bc12ded912c3a589df7b8846758968ccb00945bcd5ae6782cd45221652f840

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
