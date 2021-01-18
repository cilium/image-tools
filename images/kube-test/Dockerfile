# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG DOCKER_IMAGE=docker:19.03.8-dind@sha256:841b5eb000551dc3c30a46386ab4bfed5839ec9592c88e961236b25194ce88b9
ARG ALPINE_BASE_IMAGE=alpine:3.11.6@sha256:9a839e63dad54c3a6d1834e29692c8492d93f90c59c978c1ed79109ea4fb9a54

FROM ${DOCKER_IMAGE} as docker-dist

FROM ${ALPINE_BASE_IMAGE} as builder

RUN apk add --no-cache \
    bash \
    curl \
    && true

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/

RUN apk add --initdb --no-cache --root /out \
    alpine-baselayout \
    bash \
    ca-certificates \
    coreutils \
    git \
    make \
    && true

COPY --from=docker-dist /usr/local/bin /out/usr/local/bin

ARG KIND_VERSION=0.8.1

RUN curl --fail --show-error --silent --location \
      https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/kind-linux-amd64 \
    --output /out/usr/local/bin/kind \
    && chmod +x /out/usr/local/bin/kind

ARG KUBECTL_VERSION=1.18.3

RUN curl --fail --show-error --silent --location \
      https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    --output /out/usr/local/bin/kubectl \
    && chmod +x /out/usr/local/bin/kubectl

ARG HELM_VERSION=3.2.1

RUN curl --fail --show-error --silent --location \
     https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
   --output /tmp/helm.tgz \
   && tar -xf /tmp/helm.tgz linux-amd64/helm -C /tmp \
   && mv /tmp/linux-amd64/helm /out/usr/local/bin  \
   && rm -rf /tmp/helm.tgz /tmp/linux-amd64

COPY configure.sh /tmp/configure.sh
RUN /tmp/configure.sh

FROM scratch
ENV TESTER_CONTAINER=true
COPY --from=builder /out /
