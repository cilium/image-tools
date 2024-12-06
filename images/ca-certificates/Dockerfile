# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.21.0@sha256:e323a465c03a31ad04374fc7239144d0fd4e2b92da6e3e0655580476d3a84621

FROM ${ALPINE_BASE_IMAGE} as builder

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/

RUN apk add --initdb --no-cache --root /out \
    ca-certificates \
    && true

FROM scratch
COPY --from=builder /out/etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
