# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

REGISTRIES ?= quay.io/cilium

PUSH ?= false
EXPORT ?= false
PLATFORMS ?= linux/amd64,linux/arm64

all-images: lint maker-image tester-image compilers-image bpftool-image llvm-image network-perf-image ca-certificates-image startup-script-image checkpatch-image iptables-image


lint:
	scripts/lint.sh

.buildx_builder:
	docker buildx create --platform $(PLATFORMS) --buildkitd-flags '--debug' > $@

maker-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh image-maker images/maker $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

tester-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh image-tester images/tester $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

compilers-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh image-compilers images/compilers $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

bpftool-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh cilium-bpftool images/bpftool $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

llvm-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh cilium-llvm images/llvm $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

ca-certificates-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh ca-certificates images/ca-certificates $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

startup-script-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh startup-script images/startup-script $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

checkpatch-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh cilium-checkpatch images/checkpatch $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

network-perf-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh network-perf images/network-perf $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

iptables-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh iptables images/iptables $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)
