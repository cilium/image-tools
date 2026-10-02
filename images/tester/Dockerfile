# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG GOLANG_IMAGE=docker.io/library/golang:1.27.1@sha256:e0174e51e81218523251d85d248a90d24c3d5e81543b4f07a5d66229397db190
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

FROM ${GOLANG_IMAGE} AS go-builder

WORKDIR /go/src/github.com/cilium/image-tools/images/tester/cst

# hadolint ignore=SC2215
RUN --mount=type=bind,readwrite,target=/go/src/github.com/cilium/image-tools/images/tester \
    --mount=type=cache,target=/root/.cache \
    --mount=type=cache,target=/go/pkg \
    mkdir -p /out/bin && \
    CGO_ENABLED=0 go build -tags netgo -ldflags '-s -w -extldflags "-static"' -o /out/bin/cst

FROM ${ALPINE_BASE_IMAGE} AS test

COPY --from=go-builder /out/bin /test/bin
COPY test /test
RUN /test/bin/cst -C /test

FROM scratch
LABEL maintainer="maintainer@cilium.io"

COPY --from=go-builder /out/bin /test/bin
