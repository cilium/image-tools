# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG GOLANG_IMAGE=docker.io/library/golang:1.27.4@sha256:205c7636d74e0ffbe3d007162df7d74f859f5a8c8322dfb9f907977686c126cf
ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

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
