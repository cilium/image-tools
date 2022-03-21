ARG CILIUM_IPROUTE2_IMAGE=quay.io/cilium/cilium-iproute2:b05085b6fb7ed87857686cce1e351f6a8bef8b0b@sha256:97813bba95bb824a79743bd73c95b8b901dfddd5413d5df90005f2c92f7c3a5c
ARG CILIUM_LLVM_IMAGE=quay.io/cilium/cilium-llvm:0147a23fdada32bd51b4f313c645bcb5fbe188d6@sha256:24fd3ad32471d0e45844c856c38f1b2d4ac8bd0a2d4edf64cffaaa3fd0b21202
ARG CILIUM_BPFTOOL_IMAGE=quay.io/cilium/cilium-bpftool:b5ba881d2a7ec68d88ecd72efd60ac551c720701@sha256:458282e59657b8f779d52ae2be2cdbeecfe68c3d807ff87c97c8d5c6f97820a9
ARG GOLANG_IMAGE=docker.io/library/golang:1.18.0@sha256:03baa0921adf5fb547f48df8b16137de82b5ccc34986c22a967055379369f614

FROM ${CILIUM_LLVM_IMAGE} as llvm-dist
FROM ${CILIUM_BPFTOOL_IMAGE} as bpftool-dist
FROM ${GOLANG_IMAGE} as golang-dist

FROM ${CILIUM_IPROUTE2_IMAGE}

ENV DEBIAN_FRONTEND noninteractive
WORKDIR /tmp
RUN apt-get update && \
    apt-get install -y --no-install-recommends make binutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=golang-dist /usr/local/go /usr/local/go
RUN mkdir -p /go
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH "${GOROOT}/bin:${GOPATH}/bin:${PATH}"

COPY --from=llvm-dist /usr/local/bin/clang /bin/
COPY --from=llvm-dist /usr/local/bin/llc /bin/
COPY --from=llvm-dist /usr/local/bin/llvm-objcopy /bin/
COPY --from=bpftool-dist /usr/local/bin/bpftool /bin/
