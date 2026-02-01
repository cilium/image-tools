# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:1732033829-330cbaf@sha256:5c54f614fb8ee7939492aa4b7d74b37922d98199f5993f6d957a1637ce30eb9e
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:24.04@sha256:cd1dba651b3080c3686ecf4e3c4220f026b521fb76978881737d24f200828b2b
ARG TESTER_IMAGE=quay.io/cilium/image-tester:1755027438-ef4e849@sha256:ff0eb08901053e72afcfadc58e9d1736c6d1b257ffdf0779966d44e4872bfae5
ARG BASE_IMAGE=scratch

FROM ${TESTER_IMAGE} AS tester
FROM ${COMPILERS_IMAGE} AS builder

# renovate: datasource=github-releases depName=libbpf/bpftool
ARG BPFTOOL_VERSION="v7.6.0"
WORKDIR /bpftool
RUN git clone --recurse-submodules --branch "${BPFTOOL_VERSION}" https://github.com/libbpf/bpftool.git /bpftool

RUN \
    # From Ubuntu 24.04 builder image, libzstd must be added at the end of LIBS and LIBS_BOOTSTRAP to compile statically
    # See https://github.com/libbpf/bpftool/issues/152
    sed -i "s/\(LIBS = \$(LIBBPF) -lelf -lz\)/\1 -lzstd/; s/\(LIBS_BOOTSTRAP = \$(LIBBPF_BOOTSTRAP) -lelf -lz\)/\1 -lzstd/" /bpftool/src/Makefile \
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
