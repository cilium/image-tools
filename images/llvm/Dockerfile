# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:5569a29cea6b3ad50aeb03102aaf3dc03841197c@sha256:b15dbedb7c49816c74a765e2f6ecdb9359763b8e4e4328d794f48b9cefae9804
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:24.04@sha256:278628f08d4979fb9af9ead44277dbc9c92c2465922310916ad0c46ec9999295
ARG TESTER_IMAGE=quay.io/cilium/image-tester:dd09c8d3ef349a909fbcdc99279516baef153f22@sha256:c056d064cb47c97acd607343db5457e1d49d9338d6d8a87e93e23cc93f052c73

FROM --platform=linux/amd64 ${COMPILERS_IMAGE} AS builder

COPY checkout-llvm.sh /tmp/checkout-llvm.sh
RUN /tmp/checkout-llvm.sh

COPY build-llvm-native.sh /tmp/build-llvm-native.sh
RUN /tmp/build-llvm-native.sh

COPY build-llvm-cross-aarch64.sh /tmp/build-llvm-cross-aarch64.sh
RUN /tmp/build-llvm-cross-aarch64.sh

FROM ${UBUNTU_IMAGE} AS rootfs
ARG TARGETPLATFORM

COPY --from=builder /out/${TARGETPLATFORM}/bin /usr/local/bin
COPY test /test/llvm

FROM ${TESTER_IMAGE} AS test
COPY --from=rootfs / /
RUN /test/bin/cst -C /test/llvm

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=rootfs / /
