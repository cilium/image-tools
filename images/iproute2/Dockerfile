# syntax=docker/dockerfile:1.1-experimental

# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=docker.io/cilium/image-compilers:57f235db9a07e81c5b60c536498ecbf2501dd267@sha256:080245ac0d7d061e05613e6bf887dc3c8bb07392cd2ce265b8a4aaaad17f2125
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:20.04@sha256:8bce67040cd0ae39e0beb55bcb976a824d9966d2ac8d2e4bf6119b45505cee64
ARG TESTER_IMAGE=docker.io/cilium/image-tester:70724309b859786e0a347605e407c5261f316eb0@sha256:89cc1f577d995021387871d3dbeb771b75ab4d70073d9bcbc42e532792719781

FROM --platform=linux/amd64 ${COMPILERS_IMAGE} as builder

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

COPY --from=builder /out/${TARGETPLATFORM}/bin /usr/local/bin
COPY test /test/iproute2

FROM ${TESTER_IMAGE} as test
COPY --from=rootfs / /
RUN /test/bin/cst -C /test/iproute2

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=rootfs / /
