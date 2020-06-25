#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

if [ -z "${GITHUB_ACTIONS+x}" ] ; then
  exit 1
fi

if [ "$#" -ne 1 ] ; then
  echo "$0 supports exactly 1 argument"
fi

kube_version="${1}"

test_script="
set -o errexit
set -o pipefail
set -o nounset

kind create cluster \
  --config /etc/kind/${kube_version}/standard-github-actions-cluster.yaml \
  --kubeconfig /github/workspace/kubeconfig

kubectl get nodes --kubeconfig /github/workspace/kubeconfig --context kind-kind --output wide
kubectl apply --kubeconfig /github/workspace/kubeconfig --context kind-kind --filename https://raw.github.com/cilium/cilium/v1.8.0/install/kubernetes/quick-install.yaml
kubectl wait nodes --kubeconfig /github/workspace/kubeconfig --context kind-kind --for=condition=Ready --all --timeout=5m
"

image="local/kube-test:$(./scripts/make-image-tag.sh images/kube-test)"
docker load --input artifacts/kube-test.oci

exec docker run \
    --rm \
    --env GITHUB_ACTIONS \
    --env TEST_CONTAINER=true \
    --volume "/var/run/docker.sock:/var/run/docker.sock" \
    --volume "/home/runner/work/_temp/_github_home:/github/home" \
    --volume "/home/runner/work/_temp/_github_workflow:/github/workflow" \
    --workdir "/github/workspace" \
      "${image}" \
      bash -c "${test_script}"
