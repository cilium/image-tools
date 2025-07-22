# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:1732033829-330cbaf@sha256:5c54f614fb8ee7939492aa4b7d74b37922d98199f5993f6d957a1637ce30eb9e
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:24.04@sha256:a08e551cb33850e4740772b38217fc1796a66da2506d312abe51acda354ff061
ARG TESTER_IMAGE=quay.io/cilium/image-tester:dd09c8d3ef349a909fbcdc99279516baef153f22@sha256:c056d064cb47c97acd607343db5457e1d49d9338d6d8a87e93e23cc93f052c73
ARG BASE_IMAGE=scratch

FROM ${TESTER_IMAGE} AS tester
FROM ${COMPILERS_IMAGE} AS builder

# renovate: datasource=github-releases depName=libbpf/bpftool
ARG BPFTOOL_VERSION="v7.4.0"
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
