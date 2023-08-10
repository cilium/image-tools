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
git cherry-pick ea72b0319d7b0f0c2fcf41d121afa5d031b319d5
# Suppress git warning: inexact rename detection was skipped due to too many files. 
git config merge.renamelimit 20591
git cherry-pick 886f9ff53155075bd5f1e994f17b85d1e1b7470c
cd -

# curl --fail --show-error --silent --location "https://github.com/llvm/llvm-project/archive/${rev}.tar.gz" --output /tmp/llvm.tgz
#
# mkdir -p /src
# tar -xf /tmp/llvm.tgz -C /tmp
# mv "/tmp/llvm-project-${rev}" /src/llvm
# rm -f /tmp/llvm.tgz
