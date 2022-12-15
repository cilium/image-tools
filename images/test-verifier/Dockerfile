ARG CILIUM_IPROUTE2_IMAGE=quay.io/cilium/cilium-iproute2:f882e3fd516184703eea5ee9b3b915748b5d4ee8@sha256:f22b8aaf01952cf4b2ec959f0b8f4d242b95ce279480fbd73fded606ce0c3fa4
ARG CILIUM_LLVM_IMAGE=quay.io/cilium/cilium-llvm:3408daa17f6490a464dfc746961e28ae31964c66@sha256:ff13a1a9f973d102c6ac907d2bc38a524c8e1d26c6c1b16ed809a98925206a79
ARG CILIUM_BPFTOOL_IMAGE=quay.io/cilium/cilium-bpftool:d3093f6aeefef8270306011109be623a7e80ad1b@sha256:2c28c64195dee20ab596d70a59a4597a11058333c6b35a99da32c339dcd7df56
ARG GOLANG_IMAGE=docker.io/library/golang:1.19.4@sha256:54184d6d892f9d79dd332a6794bb11085c3f8b31f8be8e0911bed4df80044c93

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
