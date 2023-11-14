# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

REGISTRIES ?= quay.io/cilium

PUSH ?= false
EXPORT ?= false
PLATFORMs ?= linux/amd64,linux/arm64

all-images: lint maker-image update-maker-image tester-image update-tester-image compilers-image update-compilers-image bpftool-image llvm-image network-perf-image

lint:
	scripts/lint.sh

.buildx_builder:
	docker buildx create --platform $(PLATFORMS) --buildkitd-flags '--debug' > $@

update-alpine-base-image:
	scripts/update-alpine-base-image.sh

update-golang-image:
	scripts/update-golang-image.sh

update-ubuntu-image:
	scripts/update-ubuntu-image.sh

maker-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh image-maker images/maker $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

update-maker-image:
	scripts/update-maker-image.sh $(firstword $(REGISTRIES))

tester-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh image-tester images/tester $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

update-tester-image:
	scripts/update-tester-image.sh $(firstword $(REGISTRIES))

compilers-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh image-compilers images/compilers $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)

update-compilers-image:
	scripts/update-compilers-image.sh $(firstword $(REGISTRIES))

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

iptables-20.04-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh iptables-20.04 images/iptables-20.04 $(PLATFORMS) "$$(cat .buildx_builder)" $(REGISTRIES)
