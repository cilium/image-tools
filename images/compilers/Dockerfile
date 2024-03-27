# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG UBUNTU_IMAGE=docker.io/library/ubuntu:22.10@sha256:e322f4808315c387868a9135beeb11435b5b83130a8599fd7d0014452c34f489
ARG TESTER_IMAGE=quay.io/cilium/image-tester:dd09c8d3ef349a909fbcdc99279516baef153f22@sha256:c056d064cb47c97acd607343db5457e1d49d9338d6d8a87e93e23cc93f052c73

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
