# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG UBUNTU_IMAGE=docker.io/library/ubuntu:24.04@sha256:278628f08d4979fb9af9ead44277dbc9c92c2465922310916ad0c46ec9999295
ARG TESTER_IMAGE=quay.io/cilium/image-tester:1751996942-195b4d9@sha256:a5a3e2d8c597305ff5bb65185898ff52a47a6d53252957852334406830a431a0

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
