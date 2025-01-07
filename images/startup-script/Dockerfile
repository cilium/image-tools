# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.20.4@sha256:780405de0f7cf99f985dd5a4f04dfc5aae71509d89505c1ba48a88d95a0ceb7f

FROM ${ALPINE_BASE_IMAGE} as builder

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/

RUN apk add --initdb --no-cache --root /out \
    bash \
    util-linux \
    && true

COPY manage-startup-script.sh /out/usr/bin/manage-startup-script.sh

FROM ${ALPINE_BASE_IMAGE} as certs
RUN apk --no-cache add ca-certificates

FROM scratch
COPY --from=builder /out /
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
CMD [ "/usr/bin/manage-startup-script.sh" ]
