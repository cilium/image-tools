# syntax=docker/dockerfile:1.1-experimental

# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=docker.io/cilium/image-compilers:b89d4f0224e0886d523d2620268d1ff32631be5a@sha256:369679f60037ca75702bf9f7035fe90b146f1329435e5a38092dffb9fbaf401a
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:20.04@sha256:8bce67040cd0ae39e0beb55bcb976a824d9966d2ac8d2e4bf6119b45505cee64
ARG TESTER_IMAGE=docker.io/cilium/image-tester:70724309b859786e0a347605e407c5261f316eb0@sha256:89cc1f577d995021387871d3dbeb771b75ab4d70073d9bcbc42e532792719781

FROM --platform=linux/amd64 ${COMPILERS_IMAGE} as builder

COPY checkout-linux.sh /tmp/checkout-linux.sh
RUN /tmp/checkout-linux.sh

COPY build-bpftool-native.sh /tmp/build-bpftool-native.sh
RUN /tmp/build-bpftool-native.sh

COPY build-bpftool-cross-aarch64.sh /tmp/build-bpftool-cross-aarch64.sh
RUN /tmp/build-bpftool-cross-aarch64.sh

FROM ${UBUNTU_IMAGE} as rootfs
ARG TARGETPLATFORM

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
