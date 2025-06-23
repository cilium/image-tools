# Copyright 2020-2025 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:1732033829-330cbaf@sha256:5c54f614fb8ee7939492aa4b7d74b37922d98199f5993f6d957a1637ce30eb9e
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:24.04@sha256:278628f08d4979fb9af9ead44277dbc9c92c2465922310916ad0c46ec9999295
ARG TESTER_IMAGE=quay.io/cilium/image-tester:dd09c8d3ef349a909fbcdc99279516baef153f22@sha256:c056d064cb47c97acd607343db5457e1d49d9338d6d8a87e93e23cc93f052c73

FROM ${COMPILERS_IMAGE} AS builder

COPY checkout-linux.sh /tmp/checkout-linux.sh
RUN /tmp/checkout-linux.sh

COPY build-bpftool.sh /tmp/build-bpftool.sh
RUN /tmp/build-bpftool.sh

FROM ${UBUNTU_IMAGE} AS rootfs

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=SC2215
RUN --mount=type=tmpfs,target=/var/cache/apt \
    --mount=type=tmpfs,target=/var/lib/apt \
    apt-get update && \
    apt-get install -y --no-install-recommends libelf1 && \
    apt-get purge --auto-remove -y

COPY --from=builder /out/bin /usr/local/bin

FROM ${TESTER_IMAGE} AS test
COPY --from=rootfs / /
COPY test /test
RUN /test/bin/cst -C /test

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=rootfs / /
