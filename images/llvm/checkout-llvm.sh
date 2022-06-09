#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

rev="llvmorg-14.0.4"

git config --global user.email "maintainer@cilium.io"
git config --global user.name  "Cilium Maintainers"

git clone --branch "${rev}" https://github.com/llvm/llvm-project.git /src/llvm

# curl --fail --show-error --silent --location "https://github.com/llvm/llvm-project/archive/${rev}.tar.gz" --output /tmp/llvm.tgz
#
# mkdir -p /src
# tar -xf /tmp/llvm.tgz -C /tmp
# mv "/tmp/llvm-project-${rev}" /src/llvm
# rm -f /tmp/llvm.tgz
