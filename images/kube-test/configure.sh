#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

# source - release note: https://github.com/kubernetes-sigs/kind/releases/tag/v0.8.0
# TODO: automate upgrades

declare -A node_images

node_images["1.18"]="kindest/node:v1.18.2@sha256:7b27a6d0f2517ff88ba444025beae41491b016bc6af573ba467b70c5e8e0d85f"
node_images["1.17"]="kindest/node:v1.17.5@sha256:ab3f9e6ec5ad8840eeb1f76c89bb7948c77bbf76bcebe1a8b59790b8ae9a283a"
node_images["1.16"]="kindest/node:v1.16.9@sha256:7175872357bc85847ec4b1aba46ed1d12fa054c83ac7a8a11f5c268957fd5765"
node_images["1.15"]="kindest/node:v1.15.11@sha256:6cc31f3533deb138792db2c7d1ffc36f7456a06f1db5556ad3b6927641016f50"
node_images["1.14"]="kindest/node:v1.14.10@sha256:6cd43ff41ae9f02bb46c8f455d5323819aec858b99534a290517ebc181b443c6"
node_images["1.13"]="kindest/node:v1.13.12@sha256:214476f1514e47fe3f6f54d0f9e24cfb1e4cda449529791286c7161b7f9c08e7"
node_images["1.12"]="kindest/node:v1.12.10@sha256:faeb82453af2f9373447bb63f50bae02b8020968e0889c7fa308e19b348916cb"

docker_bridge_addr="172.17.0.1"
port="6443"

for kube_version in "${!node_images[@]}" ; do
mkdir -p "/out/etc/kind/${kube_version}"
cat > "/out/etc/kind/${kube_version}/standard-github-actions-cluster.yaml" << EOF
apiVersion: kind.x-k8s.io/v1alpha4
kind: Cluster
networking: # docs: https://kind.sigs.k8s.io/docs/user/configuration/#networking
  # In order for the API to be accessible from any container, Docker bridge IP is used.
  # This is specific to GitHub Actions environment, elsewhere a different address will
  # need to be used.
  apiServerAddress: "${docker_bridge_addr}"
  # Port allocation doesn't work with the Docker bridge IP, so a static port is used.
  apiServerPort: ${port}
  # This is required as Cilium will be used
  disableDefaultCNI: true
nodes:
- role: control-plane
  image: "${node_images[${kube_version}]}"
EOF
done
