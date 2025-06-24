# Copyright 2024 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:1732033829-330cbaf@sha256:5c54f614fb8ee7939492aa4b7d74b37922d98199f5993f6d957a1637ce30eb9e

FROM ${COMPILERS_IMAGE} AS builder
ARG TARGETPLATFORM

COPY checkout-llvm.sh /tmp/checkout-llvm.sh
RUN /tmp/checkout-llvm.sh

COPY build-llvm.sh /tmp/build-llvm.sh
RUN /tmp/build-llvm.sh

FROM scratch
LABEL maintainer="maintainer@cilium.io"

ARG TARGETPLATFORM
COPY --from=builder /out/${TARGETPLATFORM}/bin /
