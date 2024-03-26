# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.19.1@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b

FROM ${ALPINE_BASE_IMAGE} as builder

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/

RUN apk add --initdb --no-cache --root /out \
    bash \
    ca-certificates \
    util-linux \
    && true

COPY manage-startup-script.sh /out/usr/bin/manage-startup-script.sh

FROM scratch
COPY --from=builder /out /
CMD [ "/usr/bin/manage-startup-script.sh" ]
