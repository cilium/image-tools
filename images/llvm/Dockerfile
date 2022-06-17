# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:a990f3bb8b35b7abd54bd3c7d56ca68f8c7f6e2d@sha256:6859bc4ba2131b5cd2c2a2f5c635ad47485fcf1a0f9a90e0070903924d7e5e2f
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:20.04@sha256:626ffe58f6e7566e00254b638eb7e0f3b11d4da9675088f4781a50ae288f3322
ARG TESTER_IMAGE=quay.io/cilium/image-tester:98852499bdc497763ace7f8d041ee09676a1d989@sha256:36bc12ded912c3a589df7b8846758968ccb00945bcd5ae6782cd45221652f840

FROM --platform=linux/amd64 ${COMPILERS_IMAGE} as builder

COPY checkout-llvm.sh /tmp/checkout-llvm.sh
RUN /tmp/checkout-llvm.sh

COPY build-llvm-native.sh /tmp/build-llvm-native.sh
RUN /tmp/build-llvm-native.sh

COPY build-llvm-cross-aarch64.sh /tmp/build-llvm-cross-aarch64.sh
RUN /tmp/build-llvm-cross-aarch64.sh

FROM ${UBUNTU_IMAGE} as rootfs
ARG TARGETPLATFORM

COPY --from=builder /out/${TARGETPLATFORM}/bin /usr/local/bin
COPY test /test/llvm

FROM ${TESTER_IMAGE} as test
COPY --from=rootfs / /
RUN /test/bin/cst -C /test/llvm

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=rootfs / /
