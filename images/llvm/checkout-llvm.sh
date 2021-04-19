#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

rev="llvmorg-12.0.0"
git clone --branch "${rev}" https://github.com/llvm/llvm-project.git /src/llvm
