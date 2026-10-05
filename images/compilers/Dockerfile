# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG UBUNTU_IMAGE=docker.io/library/ubuntu:26.04@sha256:f144425ff09be612d6d9ad965196e9cdc23dae1f42110a8a11a3e9a8198759f7
ARG TESTER_IMAGE=quay.io/cilium/image-tester:1755027438-ef4e849@sha256:ff0eb08901053e72afcfadc58e9d1736c6d1b257ffdf0779966d44e4872bfae5

FROM ${UBUNTU_IMAGE} AS builder

COPY install-deps.sh /tmp/install-deps.sh
RUN /tmp/install-deps.sh

FROM ${TESTER_IMAGE} AS test
COPY --from=builder / /
COPY test /test
ARG TARGETARCH
RUN /test/bin/cst -C /test/${TARGETARCH}

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=builder / /
