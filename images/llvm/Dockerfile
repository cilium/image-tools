# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=docker.io/cilium/image-compilers:b89d4f0224e0886d523d2620268d1ff32631be5a@sha256:369679f60037ca75702bf9f7035fe90b146f1329435e5a38092dffb9fbaf401a
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:20.04@sha256:8bce67040cd0ae39e0beb55bcb976a824d9966d2ac8d2e4bf6119b45505cee64
ARG TESTER_IMAGE=docker.io/cilium/image-tester:70724309b859786e0a347605e407c5261f316eb0@sha256:89cc1f577d995021387871d3dbeb771b75ab4d70073d9bcbc42e532792719781

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
