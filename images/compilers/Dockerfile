# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG UBUNTU_IMAGE=docker.io/library/ubuntu:24.04@sha256:278628f08d4979fb9af9ead44277dbc9c92c2465922310916ad0c46ec9999295
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
