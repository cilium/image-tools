# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG GOLANG_IMAGE=docker.io/library/golang:1.26.2@sha256:5f3787b7f902c07c7ec4f3aa91a301a3eda8133aa32661a3b3a3a86ab3a68a36
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659

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
