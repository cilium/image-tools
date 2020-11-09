#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

mkdir -p /src/llvm/llvm/build-native

cd /src/llvm/llvm/build-native

cmake .. -G "Ninja" \
  -DLLVM_TARGETS_TO_BUILD="BPF" \
  -DLLVM_ENABLE_PROJECTS="clang" \
  -DBUILD_SHARED_LIBS="OFF" \
  -DCMAKE_BUILD_TYPE="Release" \
  -DLLVM_BUILD_RUNTIME="OFF" \
  -DCMAKE_INSTALL_PREFIX="/usr/local"

ninja clang llc llvm-objcopy

strip bin/clang
strip bin/llc
strip bin/llvm-objcopy

mkdir -p /out/linux/amd64/bin
cp bin/clang bin/llc bin/llvm-objcopy /out/linux/amd64/bin
