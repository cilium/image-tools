# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

ARG COMPILERS_IMAGE=quay.io/cilium/image-compilers:1732033829-330cbaf@sha256:5c54f614fb8ee7939492aa4b7d74b37922d98199f5993f6d957a1637ce30eb9e
ARG UBUNTU_IMAGE=docker.io/library/ubuntu:24.04@sha256:a08e551cb33850e4740772b38217fc1796a66da2506d312abe51acda354ff061
ARG TESTER_IMAGE=quay.io/cilium/image-tester:1755027438-ef4e849@sha256:ff0eb08901053e72afcfadc58e9d1736c6d1b257ffdf0779966d44e4872bfae5
ARG BASE_IMAGE=scratch

FROM ${TESTER_IMAGE} AS tester
FROM ${COMPILERS_IMAGE} AS builder

ARG LLVM_VERSION="llvmorg-19.1.7"
ADD https://github.com/llvm/llvm-project/archive/${LLVM_VERSION}.tar.gz /tmp/llvm.tar.gz
WORKDIR /src/llvm
RUN tar -xf /tmp/llvm.tar.gz --strip-components=1 --directory /src/llvm

WORKDIR /src/llvm/llvm/build
COPY build-llvm.sh /tmp/build-llvm.sh
RUN /tmp/build-llvm.sh

FROM ${UBUNTU_IMAGE} AS test
COPY --from=builder /out/bin /usr/local/bin
COPY test /test
COPY --from=tester /test/bin /test/bin
RUN /test/bin/cst -C /test

FROM ${BASE_IMAGE} AS release
LABEL maintainer="maintainer@cilium.io"
COPY --from=builder /out/bin /usr/local/bin
