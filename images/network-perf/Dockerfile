ARG BASE_IMAGE=registry.access.redhat.com/ubi8/ubi@sha256:a7e3d45d7ab598aefed9e2691ad9c368bb6b2db06f4cd4473d32eabfd0078519

FROM ${BASE_IMAGE} AS builder

# We can ignore this warning here because we run `dnf clean all` later and then squash all layers in the final image
# hadolint ignore=DL3040
RUN dnf install -y --nodocs gcc make

# Install and configure iperf
# renovate: datasource=github-releases depName=esnet/iperf
ARG IPERF_VERSION="3.20"
WORKDIR /iperf
RUN curl -L -o iperf.tar.gz https://github.com/esnet/iperf/archive/refs/tags/${IPERF_VERSION}.tar.gz && \
    tar xzf iperf.tar.gz --strip-components=1 -C /iperf && \
    ./configure && \
    make && \
    make install && \
    rm -rf /iperf

# Install and configure netperf
ARG NETPERF_VERSION=80bf19d563eebd1eca23f4092f96819296020fa5
WORKDIR /netperf
RUN curl -L -o netperf.tar.gz https://github.com/HewlettPackard/netperf/archive/${NETPERF_VERSION}.tar.gz && \
    tar xzf netperf.tar.gz --strip-components=1 -C /netperf && \
    ./configure && \
    make && \
    make install && \
    rm -rf /netperf

# Remove build dependencies
RUN dnf remove -y gcc make && \
    dnf clean all

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=builder / /
