# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG GOLANG_IMAGE=docker.io/library/golang:1.24.4@sha256:20a022e5112a144aa7b7aeb3f22ebf2cdaefcc4aac0d64e8deeee8cdc18b9c0f
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

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
