#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

triplet="aarch64-linux-gnu"

mkdir -p /src/llvm/llvm/build-cross-aarch64

cd /src/llvm/llvm/build-cross-aarch64

CC="${triplet}-gcc" CXX="${triplet}-g++" \
  cmake .. -G "Ninja" \
    -DLLVM_TARGETS_TO_BUILD="BPF" \
    -DLLVM_ENABLE_PROJECTS="clang" \
    -DBUILD_SHARED_LIBS="OFF" \
    -DCMAKE_BUILD_TYPE="Release" \
    -DLLVM_BUILD_RUNTIME="OFF" \
    -DLLVM_TABLEGEN="/src/llvm/llvm/build-native/bin/llvm-tblgen" \
    -DCLANG_TABLEGEN="/src/llvm/llvm/build-native/bin/clang-tblgen" \
    -DCMAKE_CROSSCOMPILING="True" \
    -DCMAKE_INSTALL_PREFIX="/usr/local"

ninja clang llc llvm-objcopy

${triplet}-strip bin/clang
${triplet}-strip bin/llc
${triplet}-strip bin/llvm-objcopy

mkdir -p /out/linux/arm64/bin
cp bin/clang bin/llc bin/llvm-objcopy /out/linux/arm64/bin
