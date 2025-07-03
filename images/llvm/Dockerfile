# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:1732033829-330cbaf@sha256:5c54f614fb8ee7939492aa4b7d74b37922d98199f5993f6d957a1637ce30eb9e
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:24.04@sha256:278628f08d4979fb9af9ead44277dbc9c92c2465922310916ad0c46ec9999295
ARG TESTER_IMAGE=quay.io/cilium/image-tester:1751996942-195b4d9@sha256:a5a3e2d8c597305ff5bb65185898ff52a47a6d53252957852334406830a431a0

FROM ${COMPILERS_IMAGE} AS builder

COPY checkout-llvm.sh /tmp/checkout-llvm.sh
RUN /tmp/checkout-llvm.sh

COPY build-llvm.sh /tmp/build-llvm.sh
RUN /tmp/build-llvm.sh

FROM ${UBUNTU_IMAGE} AS rootfs

COPY --from=builder /out/bin /usr/local/bin

FROM ${TESTER_IMAGE} AS test
COPY --from=rootfs / /
COPY test /test
RUN /test/bin/cst -C /test

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=rootfs / /
