# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659

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
