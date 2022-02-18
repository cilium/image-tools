# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

REGISTRIES ?= quay.io/cilium

PUSH ?= false
EXPORT ?= false

all-images: lint maker-image update-maker-image tester-image update-tester-image compilers-image update-compilers-image bpftool-image iproute2-image llvm-image iperf3-image

lint:
	scripts/lint.sh

.buildx_builder:
	docker buildx create --platform linux/amd64,linux/arm64 --buildkitd-flags '--debug' > $@

update-alpine-base-image:
	scripts/update-alpine-base-image.sh

update-golang-image:
	scripts/update-golang-image.sh

update-ubuntu-image:
	scripts/update-ubuntu-image.sh

maker-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh image-maker images/maker linux/amd64 "$$(cat .buildx_builder)" $(REGISTRIES)

update-maker-image:
	scripts/update-maker-image.sh $(firstword $(REGISTRIES))

tester-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh image-tester images/tester linux/amd64,linux/arm64 "$$(cat .buildx_builder)" $(REGISTRIES)

update-tester-image:
	scripts/update-tester-image.sh $(firstword $(REGISTRIES))

compilers-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh image-compilers images/compilers linux/amd64 "$$(cat .buildx_builder)" $(REGISTRIES)

update-compilers-image:
	scripts/update-compilers-image.sh $(firstword $(REGISTRIES))

bpftool-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh cilium-bpftool images/bpftool linux/amd64,linux/arm64 "$$(cat .buildx_builder)" $(REGISTRIES)

iproute2-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh cilium-iproute2 images/iproute2 linux/amd64,linux/arm64 "$$(cat .buildx_builder)" $(REGISTRIES)

llvm-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) TEST=true scripts/build-image.sh cilium-llvm images/llvm linux/amd64,linux/arm64 "$$(cat .buildx_builder)" $(REGISTRIES)

ca-certificates-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh ca-certificates images/ca-certificates linux/amd64,linux/arm64 "$$(cat .buildx_builder)" $(REGISTRIES)

startup-script-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh startup-script images/startup-script linux/amd64,linux/arm64 "$$(cat .buildx_builder)" $(REGISTRIES)

checkpatch-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh cilium-checkpatch images/checkpatch linux/amd64 "$$(cat .buildx_builder)" $(REGISTRIES)

test-verifier-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh test-verifier images/test-verifier linux/amd64 "$$(cat .buildx_builder)" $(REGISTRIES)

iperf3-image: .buildx_builder
	PUSH=$(PUSH) EXPORT=$(EXPORT) scripts/build-image.sh iperf3 images/iperf3 linux/amd64 "$$(cat .buildx_builder)" $(REGISTRIES)
