# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

REGISTRIES ?= docker.io/cilium
# quay.io is not enabled, see https://github.com/cilium/image-tools/issues/11
# REGISTRIES ?= docker.io/cilium quay.io/cilium

PUSH ?= false

OUTPUT := "type=docker"
ifeq ($(PUSH),true)
OUTPUT := "type=registry,push=true"
endif

all-images: lint maker-image update-maker-image compilers-image update-compilers-image bpftool-image iproute2-image llvm-image

lint:
	scripts/lint.sh

.buildx_builder:
	# see https://github.com/docker/buildx/issues/308
	mkdir -p .buildx
	docker buildx create --platform linux/amd64,linux/arm64 --buildkitd-flags '--debug' > $@

update-alpine-base-image:
	scripts/update-alpine-base-image.sh

maker-image: .buildx_builder
	scripts/build-image.sh image-maker images/maker linux/amd64 $(OUTPUT) "$$(cat .buildx_builder)" $(REGISTRIES)

update-maker-image:
	scripts/update-maker-image.sh $(firstword $(REGISTRIES))

compilers-image: .buildx_builder
	scripts/build-image.sh image-compilers images/compilers linux/amd64 $(OUTPUT) "$$(cat .buildx_builder)" $(REGISTRIES)

update-compilers-image:
	scripts/update-compilers-image.sh $(firstword $(REGISTRIES))

bpftool-image: .buildx_builder
	scripts/build-image.sh cilium-bpftool images/bpftool linux/amd64,linux/arm64 $(OUTPUT) "$$(cat .buildx_builder)" $(REGISTRIES)

iproute2-image: .buildx_builder
	scripts/build-image.sh cilium-iproute2 images/iproute2 linux/amd64,linux/arm64 $(OUTPUT) "$$(cat .buildx_builder)" $(REGISTRIES)

llvm-image: .buildx_builder
	scripts/build-image.sh cilium-llvm images/llvm linux/amd64,linux/arm64 $(OUTPUT) "$$(cat .buildx_builder)" $(REGISTRIES)

ca-certificates-image: .buildx_builder
	scripts/build-image.sh ca-certificates images/ca-certificates linux/amd64,linux/arm64 $(OUTPUT) "$$(cat .buildx_builder)" $(REGISTRIES)

startup-script-image: .buildx_builder
	scripts/build-image.sh startup-script images/startup-script linux/amd64,linux/arm64 $(OUTPUT) "$$(cat .buildx_builder)" $(REGISTRIES)
