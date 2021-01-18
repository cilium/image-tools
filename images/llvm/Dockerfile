# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=docker.io/cilium/image-compilers:07ffd7516e5af3a4b369f676b893be6305ad75f6@sha256:d2effda204586017ee93dca53691e4a34bf24a36a6811b8b41c419119ceef68f
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:20.04@sha256:8bce67040cd0ae39e0beb55bcb976a824d9966d2ac8d2e4bf6119b45505cee64
ARG TESTER_IMAGE=docker.io/cilium/image-tester:8db378d50308ae85095b389abd9d84ae72c8236c@sha256:b548c7e931c9753eff1c28be6010c6c9302d9f5b8518d41a94373f10bb0dc52e

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
