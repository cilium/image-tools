# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG GOLANG_IMAGE=docker.io/library/golang:1.26.5@sha256:705e964a93a2fd2e75c7d59bb7d781b57e30f12293ffde5175c69229e18fb678
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

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
