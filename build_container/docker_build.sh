#!/bin/bash
set -ex

IMAGE_TAG=${1:-latest}
DOCKER_REPOSITORY=${2:-cilium}
DOCKER_REGISTRY=${3:-quay.io}
IMAGE_ARCH=("amd64" "arm64")

SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

docker buildx rm  multi-builder | true
docker buildx create --use --name multi-builder --platform linux/arm64,linux/amd64
docker buildx build --platform linux/amd64,linux/arm64  --push -f ${SCRIPTS_DIR}/../Dockerfile.bpftool . -t ${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}/cilium-bpftool:${IMAGE_TAG}
docker buildx build --platform linux/amd64,linux/arm64  --push -f ${SCRIPTS_DIR}/../Dockerfile.iproute2 . -t ${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}/cilium-iproute2:${IMAGE_TAG}
docker buildx build --platform linux/amd64,linux/arm64  --push -f ${SCRIPTS_DIR}/../Dockerfile.llvm . -t ${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}/cilium-llvm:${IMAGE_TAG}
