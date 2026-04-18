# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:1732033829-330cbaf@sha256:5c54f614fb8ee7939492aa4b7d74b37922d98199f5993f6d957a1637ce30eb9e
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:24.04@sha256:c4a8d5503dfb2a3eb8ab5f807da5bc69a85730fb49b5cfca2330194ebcc41c7b
ARG TESTER_IMAGE=quay.io/cilium/image-tester:1755027438-ef4e849@sha256:ff0eb08901053e72afcfadc58e9d1736c6d1b257ffdf0779966d44e4872bfae5
ARG BASE_IMAGE=scratch

FROM ${TESTER_IMAGE} AS tester
FROM ${COMPILERS_IMAGE} AS builder

# renovate: datasource=github-releases depName=libbpf/bpftool
ARG BPFTOOL_VERSION="v7.7.0"
WORKDIR /bpftool
RUN git clone --recurse-submodules --branch "${BPFTOOL_VERSION}" https://github.com/libbpf/bpftool.git /bpftool

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends libssl-dev \
    && make -C src EXTRA_CFLAGS=--static BPFTOOL_VERSION="${BPFTOOL_VERSION#v}" -j "$(nproc)" \
    && strip /bpftool/src/bpftool \
    && mkdir -p /out/bin \
    && mv /bpftool/src/bpftool /out/bin/

FROM ${UBUNTU_IMAGE} AS test
COPY --from=builder /out/bin/bpftool /usr/local/bin/bpftool
COPY test /test
COPY --from=tester /test/bin /test/bin
RUN /test/bin/cst -C /test

FROM ${BASE_IMAGE} AS release
LABEL maintainer="maintainer@cilium.io"
COPY --from=builder /out/bin/bpftool /usr/local/bin/bpftool
