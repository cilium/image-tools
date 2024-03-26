# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

# This file builds iptables 1.8.8-1 from source using Ubuntu 22.04
# The source code comes from Debian Bookworm snapshots
# To upgrade to a new iptables version, change also the snapshot date.

ARG IPTABLES_VERSION=1.8.8-1
ARG SNAPSHOT_DATE=20230116T212610Z

FROM docker.io/library/ubuntu:22.10@sha256:e322f4808315c387868a9135beeb11435b5b83130a8599fd7d0014452c34f489

RUN mkdir /iptables
WORKDIR /iptables

ARG IPTABLES_VERSION
ARG SNAPSHOT_DATE

RUN apt-get update && \
    apt-get install -y --no-install-recommends debian-archive-keyring apt-src ca-certificates && \
    echo "deb-src [check-valid-until=no signed-by=/usr/share/keyrings/debian-archive-bullseye-automatic.gpg] https://snapshot.debian.org/archive/debian/${SNAPSHOT_DATE}/ bookworm main" > /etc/apt/sources.list.d/iptables-snapshot.list && \
    apt-get update && \
    apt-src -b install iptables=${IPTABLES_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
