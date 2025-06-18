# syntax=docker/dockerfile:1.1-experimental@sha256:de85b2f3a3e8a2f7fe48e8e84a65f6fdd5cd5183afa6412fff9caa6871649c44

# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG GOLANG_IMAGE=docker.io/library/golang:1.24.4@sha256:10c131810f80a4802c49cab0961bbe18a16f4bb2fb99ef16deaa23e4246fc817
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

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
