# syntax=docker/dockerfile:1.1-experimental

# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:c1ba0665b6f9f012d014a642d9882f7c38bdf365@sha256:01c7c957e9b0fc200644996c6bedac297c98b81dea502a3bc3047837e67a7fcb
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:20.04@sha256:8bce67040cd0ae39e0beb55bcb976a824d9966d2ac8d2e4bf6119b45505cee64
ARG TESTER_IMAGE=quay.io/cilium/image-tester:6316b0f5606a69078bed1dd9f9c2b5685fede3b0@sha256:f180855b1fb965e05dd02f57019e070569c4d7f2ef0f7bdaaa30bf3393a2ce7a

FROM --platform=linux/amd64 ${COMPILERS_IMAGE} as builder

COPY checkout-linux.sh /tmp/checkout-linux.sh
RUN /tmp/checkout-linux.sh

COPY build-bpftool-native.sh /tmp/build-bpftool-native.sh
RUN /tmp/build-bpftool-native.sh

COPY build-bpftool-cross-aarch64.sh /tmp/build-bpftool-cross-aarch64.sh
RUN /tmp/build-bpftool-cross-aarch64.sh

FROM ${UBUNTU_IMAGE} as rootfs
ARG TARGETPLATFORM

ENV DEBIAN_FRONTEND noninteractive

# hadolint ignore=SC2215
RUN --mount=type=tmpfs,target=/var/cache/apt --mount=type=tmpfs,target=/var/lib/apt \
  apt-get update \
    && apt-get install -y --no-install-recommends libelf1 \
    && apt-get purge --auto-remove -y

COPY --from=builder /out/${TARGETPLATFORM}/bin /usr/local/bin
COPY test /test/bpftool

FROM ${TESTER_IMAGE} as test
COPY --from=rootfs / /
RUN /test/bin/cst -C /test/bpftool

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=rootfs / /
