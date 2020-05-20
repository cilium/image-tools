# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=docker.io/cilium/image-compilers:818f48aa3eada1d23018f02f3c43a169c51eea1a@sha256:54e7c0d8713f479e578dbcfd915795db9b12761d6397bf7ef61ae4b1d2031f03

FROM --platform=linux/amd64 ${COMPILERS_IMAGE} as builder

COPY checkout-linux.sh /tmp/checkout-linux.sh
RUN /tmp/checkout-linux.sh

COPY build-bpftool-native.sh /tmp/build-bpftool-native.sh
RUN /tmp/build-bpftool-native.sh

COPY build-bpftool-cross-aarch64.sh /tmp/build-bpftool-cross-aarch64.sh
RUN /tmp/build-bpftool-cross-aarch64.sh

FROM scratch
LABEL maintainer="maintainer@cilium.io"
ARG TARGETPLATFORM
COPY --from=builder /out/${TARGETPLATFORM}/bin /bin
