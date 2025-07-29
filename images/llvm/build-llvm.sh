#!/usr/bin/env bash

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

mkdir -p /src/llvm/llvm/build
cd /src/llvm/llvm/build

cmake .. -G "Ninja" \
    -DLLVM_TARGETS_TO_BUILD="BPF" \
    -DLLVM_ENABLE_PROJECTS="clang" \
    -DBUILD_SHARED_LIBS="OFF" \
    -DLLVM_BUILD_STATIC="ON" \
    -DCMAKE_CXX_FLAGS="-s -flto" \
    -DCMAKE_BUILD_TYPE="Release" \
    -DLLVM_BUILD_RUNTIME="OFF" \
    -DCMAKE_INSTALL_PREFIX="/usr/local"

ninja clang llc llvm-objcopy llvm-strip

strip bin/clang
strip bin/llc
strip bin/llvm-objcopy
strip bin/llvm-strip

mkdir -p /out/bin
cp bin/clang bin/llc bin/llvm-objcopy bin/llvm-strip /out/bin
