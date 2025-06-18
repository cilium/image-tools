# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG ALPINE_BASE_IMAGE=docker.io/library/alpine:3.20.6@sha256:de4fe7064d8f98419ea6b49190df1abbf43450c1702eeb864fe9ced453c1cc5f

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
