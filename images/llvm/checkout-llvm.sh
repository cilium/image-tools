#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

rev="llvmorg-10.0.0"

git config --global user.email "maintainer@cilium.io"
git config --global user.name  "Cilium Maintainers"

git clone --branch "${rev}" https://github.com/llvm/llvm-project.git /src/llvm

cd /src/llvm
git cherry-pick 29bc5dd19407c4d7cad1c059dea26ee216ddc7ca
git cherry-pick 13f6c81c5d9a7a34a684363bcaad8eb7c65356fd
cd -

# curl --fail --show-error --silent --location "https://github.com/llvm/llvm-project/archive/${rev}.tar.gz" --output /tmp/llvm.tgz
#
# mkdir -p /src
# tar -xf /tmp/llvm.tgz -C /tmp
# mv "/tmp/llvm-project-${rev}" /src/llvm
# rm -f /tmp/llvm.tgz
