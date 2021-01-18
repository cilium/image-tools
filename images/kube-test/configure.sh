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

node_images["1.19"]="kindest/node:v1.19.1@sha256:98cf5288864662e37115e362b23e4369c8c4a408f99cbc06e58ac30ddc721600"
node_images["1.18"]="kindest/node:v1.18.8@sha256:f4bcc97a0ad6e7abaf3f643d890add7efe6ee4ab90baeb374b4f41a4c95567eb"
node_images["1.17"]="kindest/node:v1.17.11@sha256:5240a7a2c34bf241afb54ac05669f8a46661912eab05705d660971eeb12f6555"
node_images["1.16"]="kindest/node:v1.16.15@sha256:a89c771f7de234e6547d43695c7ab047809ffc71a0c3b65aa54eda051c45ed20"
node_images["1.15"]="kindest/node:v1.15.12@sha256:d9b939055c1e852fe3d86955ee24976cab46cba518abcb8b13ba70917e6547a6"
node_images["1.14"]="kindest/node:v1.14.10@sha256:ce4355398a704fca68006f8a29f37aafb49f8fc2f64ede3ccd0d9198da910146"
node_images["1.13"]="kindest/node:v1.13.12@sha256:1c1a48c2bfcbae4d5f4fa4310b5ed10756facad0b7a2ca93c7a4b5bae5db29f5"

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
