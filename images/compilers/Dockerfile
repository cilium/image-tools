# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG UBUNTU_IMAGE=docker.io/library/ubuntu:24.04@sha256:a08e551cb33850e4740772b38217fc1796a66da2506d312abe51acda354ff061
ARG TESTER_IMAGE=quay.io/cilium/image-tester:1755027438-ef4e849@sha256:ff0eb08901053e72afcfadc58e9d1736c6d1b257ffdf0779966d44e4872bfae5

FROM ${UBUNTU_IMAGE} as builder

COPY install-deps.sh /tmp/install-deps.sh
RUN /tmp/install-deps.sh

FROM ${TESTER_IMAGE} as test
COPY --from=builder / /
COPY test /test
ARG TARGETARCH
RUN /test/bin/cst -C /test/${TARGETARCH}

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=builder / /
