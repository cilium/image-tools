# syntax=docker/dockerfile:1.1-experimental

# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG GOLANG_IMAGE=docker.io/library/golang:1.16.3@sha256:c5dc03c9aa88068b6830f1d625071ed9726a028e49e50656883a67ea6734ca6c
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.11@sha256:9a839e63dad54c3a6d1834e29692c8492d93f90c59c978c1ed79109ea4fb9a54

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
