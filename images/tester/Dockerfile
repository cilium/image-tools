# syntax=docker/dockerfile:1.1-experimental

# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG GOLANG_IMAGE=docker.io/library/golang:1.20.1@sha256:2edf6aab2d57644f3fe7407132a0d1770846867465a39c2083770cf62734b05d
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.18.0@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11

FROM --platform=linux/amd64 ${GOLANG_IMAGE} as go-builder

COPY . /go/src/github.com/cilium/image-tools/images/tester
RUN mkdir -p /out/linux/amd64/bin /out/linux/arm64/bin

WORKDIR /go/src/github.com/cilium/image-tools/images/tester/cst

# hadolint ignore=SC2215
RUN --mount=target=/root/.cache,type=cache --mount=target=/go/pkg/mod,type=cache \
  env CGO_ENABLED=0 \
    go build -tags netgo -ldflags '-s -w -extldflags "-static"' -o /out/linux/amd64/bin/cst

# hadolint ignore=SC2215
RUN --mount=target=/root/.cache,type=cache --mount=target=/go/pkg/mod,type=cache \
  env CGO_ENABLED=0 GOARCH=arm64 \
    go build -tags netgo -ldflags '-s -w -extldflags "-static"' -o /out/linux/arm64/bin/cst

FROM ${ALPINE_BASE_IMAGE} as test
ARG TARGETPLATFORM
COPY --from=go-builder /out/${TARGETPLATFORM}/bin /test/bin
COPY test /test
RUN /test/bin/cst

FROM scratch
LABEL maintainer="maintainer@cilium.io"
ARG TARGETPLATFORM
COPY --from=go-builder /out/${TARGETPLATFORM}/bin /test/bin
