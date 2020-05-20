# Copyright 2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

REGISTRY_PREFIX ?= docker.io/cilium
PUSH ?= false

OUTPUT := "type=docker"
ifeq ($(PUSH),true)
OUTPUT := "type=registry,push=true"
endif

all-images: lint maker-image update-maker-image compilers-image update-compilers-image bpftool-image iproute2-image llvm-image

lint:
	scripts/lint.sh

.buildx_builder:
	mkdir -p .buildx
	docker buildx create --platform linux/amd64,linux/arm64 > $@

maker-image: .buildx_builder
	scripts/build-image.sh $(REGISTRY_PREFIX)/image-maker images/maker linux/amd64 $(OUTPUT) "$$(cat .buildx_builder)"

update-maker-image:
	scripts/update-maker-image.sh $(REGISTRY_PREFIX)

compilers-image: .buildx_builder
	scripts/build-image.sh $(REGISTRY_PREFIX)/image-compilers images/compilers linux/amd64 $(OUTPUT) "$$(cat .buildx_builder)"

update-compilers-image:
	scripts/update-compilers-image.sh $(REGISTRY_PREFIX)

bpftool-image: .buildx_builder
	scripts/build-image.sh $(REGISTRY_PREFIX)/bpftool images/bpftool linux/amd64,linux/arm64 $(OUTPUT) "$$(cat .buildx_builder)"

iproute2-image: .buildx_builder
	scripts/build-image.sh $(REGISTRY_PREFIX)/iproute2 images/iproute2 linux/amd64,linux/arm64 $(OUTPUT) "$$(cat .buildx_builder)"

llvm-image: .buildx_builder
	scripts/build-image.sh $(REGISTRY_PREFIX)/llvm images/llvm linux/amd64,linux/arm64 $(OUTPUT) "$$(cat .buildx_builder)"
