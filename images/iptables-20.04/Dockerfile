# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

# This file builds iptables 1.8.8-1 from source using Ubuntu 20.04
# The source code comes from Debian Bookworm snapshots
# To upgrade to a new iptables version, change also the snapshot date.

ARG IPTABLES_VERSION=1.8.8-1
ARG SNAPSHOT_DATE=20230116T212610Z

FROM docker.io/library/ubuntu:20.04@sha256:0e0402cd13f68137edb0266e1d2c682f217814420f2d43d300ed8f65479b14fb

RUN mkdir /iptables
WORKDIR /iptables

ARG IPTABLES_VERSION
ARG SNAPSHOT_DATE

RUN apt-get update && \
    apt-get install -y --no-install-recommends debian-archive-keyring apt-src ca-certificates && \
    echo 'deb [signed-by=/usr/share/keyrings/debian-archive-buster-automatic.gpg] http://deb.debian.org/debian bullseye main' > /etc/apt/sources.list.d/debian-bullseye.list && \
    echo "deb-src [check-valid-until=no signed-by=/usr/share/keyrings/debian-archive-buster-automatic.gpg] https://snapshot.debian.org/archive/debian/${SNAPSHOT_DATE}/ bookworm main" > /etc/apt/sources.list.d/iptables-snapshot.list && \
    apt-get update && \
    apt-src -b install iptables=${IPTABLES_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
