#!/bin/bash

# Copyright 2017-2024 Authors of Cilium
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
  -DLLVM_BUILD_STATIC="ON" \
  -DCMAKE_CXX_FLAGS="-s -flto" \
  -DCMAKE_BUILD_TYPE="Release" \
  -DLLVM_BUILD_RUNTIME="OFF" \
  -DCMAKE_INSTALL_PREFIX="/usr/local"

# llvm-tblgen and clang-tblgen are needed to build the aarch64 version of clang-format
ninja clang-format llvm-tblgen clang-tblgen

strip bin/clang-format

mkdir -p /out/linux/amd64/bin
cp bin/clang-format /out/linux/amd64/bin
