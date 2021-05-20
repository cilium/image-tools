ARG CILIUM_LLVM_IMAGE=quay.io/cilium/cilium-llvm:0147a23fdada32bd51b4f313c645bcb5fbe188d6@sha256:24fd3ad32471d0e45844c856c38f1b2d4ac8bd0a2d4edf64cffaaa3fd0b21202
ARG CILIUM_BPFTOOL_IMAGE=quay.io/cilium/cilium-bpftool:b5ba881d2a7ec68d88ecd72efd60ac551c720701@sha256:458282e59657b8f779d52ae2be2cdbeecfe68c3d807ff87c97c8d5c6f97820a9
ARG GOLANG_IMAGE=docker.io/library/golang:1.16.4@sha256:07a471a939cd942ed5c23714185dac476df214f94cf073ef2fbfa748d4926a48

FROM ${CILIUM_LLVM_IMAGE} as llvm-dist
FROM ${CILIUM_BPFTOOL_IMAGE} as bpftool-dist
FROM ${GOLANG_IMAGE} as golang-dist

FROM docker.io/library/ubuntu:20.04@sha256:b4aa552dd3f2ed84f3214b0e8add3648aee0205ef58295c92fe0899f96ad8755

ENV DEBIAN_FRONTEND noninteractive
WORKDIR /tmp
COPY iproute2.diff .
COPY install-tc-ip.sh .
RUN apt-get update && \
    apt-get install -y --no-install-recommends make gcc libelf-dev libmnl-dev && \
    ./install-tc-ip.sh && \
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
