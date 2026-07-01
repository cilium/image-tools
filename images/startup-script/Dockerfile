# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.23.5@sha256:fd791d74b68913cbb027c6546007b3f0d3bc45125f797758156952bc2d6daf40

FROM ${ALPINE_BASE_IMAGE} AS builder

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/

RUN apk add --initdb --no-cache --root /out \
    bash \
    util-linux \
    && apk --no-cache upgrade

COPY manage-startup-script.sh /out/usr/bin/manage-startup-script.sh

FROM ${ALPINE_BASE_IMAGE} AS certs
RUN apk --no-cache add ca-certificates

FROM scratch
COPY --from=builder /out /
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
CMD [ "/usr/bin/manage-startup-script.sh" ]
