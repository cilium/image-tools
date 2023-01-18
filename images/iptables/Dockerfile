# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG IPTABLES_VERSION=1.8.8-1

FROM docker.io/library/ubuntu:22.04@sha256:27cb6e6ccef575a4698b66f5de06c7ecd61589132d5a91d098f7f3f9285415a9

RUN mkdir /iptables
WORKDIR /iptables

ARG IPTABLES_VERSION

RUN apt-get update && \
    apt-get install -y --no-install-recommends debian-archive-keyring apt-src && \
    echo 'deb-src [signed-by=/usr/share/keyrings/debian-archive-bullseye-automatic.gpg] http://deb.debian.org/debian bookworm main' > /etc/apt/sources.list.d/debian-testing.list && \
    apt-get update && \
    apt-src -b install iptables=${IPTABLES_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
