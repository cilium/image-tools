# syntax=docker/dockerfile:1.1-experimental

# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:c1ba0665b6f9f012d014a642d9882f7c38bdf365@sha256:01c7c957e9b0fc200644996c6bedac297c98b81dea502a3bc3047837e67a7fcb
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:22.04@sha256:26c68657ccce2cb0a31b330cb0be2b5e108d467f641c62e13ab40cbec258c68d
ARG TESTER_IMAGE=quay.io/cilium/image-tester:98852499bdc497763ace7f8d041ee09676a1d989@sha256:36bc12ded912c3a589df7b8846758968ccb00945bcd5ae6782cd45221652f840

FROM --platform=linux/amd64 ${COMPILERS_IMAGE} as builder

COPY checkout-libbpf.sh /tmp/checkout-libbpf.sh
RUN /tmp/checkout-libbpf.sh

COPY build-libbpf-native.sh /tmp/build-libbpf-native.sh
RUN /tmp/build-libbpf-native.sh

COPY build-libbpf-cross-aarch64.sh /tmp/build-libbpf-cross-aarch64.sh
RUN /tmp/build-libbpf-cross-aarch64.sh

COPY checkout-iproute2.sh /tmp/checkout-iproute2.sh
RUN /tmp/checkout-iproute2.sh

COPY build-iproute2-native.sh /tmp/build-iproute2-native.sh
RUN /tmp/build-iproute2-native.sh

COPY build-iproute2-cross-aarch64.sh /tmp/build-iproute2-cross-aarch64.sh
RUN /tmp/build-iproute2-cross-aarch64.sh

FROM ${UBUNTU_IMAGE} as rootfs
ARG TARGETPLATFORM

ENV DEBIAN_FRONTEND noninteractive

# hadolint ignore=SC2215
RUN --mount=type=tmpfs,target=/var/cache/apt --mount=type=tmpfs,target=/var/lib/apt \
  apt-get update \
    && apt-get install -y --no-install-recommends libelf1 libmnl0 \
    && apt-get purge --auto-remove -y

COPY --from=builder /out/${TARGETPLATFORM}/lib64 /usr/lib
COPY --from=builder /out/${TARGETPLATFORM}/bin /usr/local/bin
COPY test /test/iproute2

FROM ${TESTER_IMAGE} as test
COPY --from=rootfs / /
RUN /test/bin/cst -C /test/iproute2

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=rootfs / /
