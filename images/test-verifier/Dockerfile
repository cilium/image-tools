ARG UBUNTU_IMAGE=docker.io/library/ubuntu:22.04@sha256:26c68657ccce2cb0a31b330cb0be2b5e108d467f641c62e13ab40cbec258c68d
ARG CILIUM_LLVM_IMAGE=quay.io/cilium/cilium-llvm:3408daa17f6490a464dfc746961e28ae31964c66@sha256:ff13a1a9f973d102c6ac907d2bc38a524c8e1d26c6c1b16ed809a98925206a79
ARG CILIUM_BPFTOOL_IMAGE=quay.io/cilium/cilium-bpftool:d3093f6aeefef8270306011109be623a7e80ad1b@sha256:2c28c64195dee20ab596d70a59a4597a11058333c6b35a99da32c339dcd7df56
ARG GOLANG_IMAGE=docker.io/library/golang:1.20.1@sha256:2edf6aab2d57644f3fe7407132a0d1770846867465a39c2083770cf62734b05d

FROM ${CILIUM_LLVM_IMAGE} as llvm-dist
FROM ${CILIUM_BPFTOOL_IMAGE} as bpftool-dist
FROM ${GOLANG_IMAGE} as golang-dist

FROM ${UBUNTU_IMAGE}

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
