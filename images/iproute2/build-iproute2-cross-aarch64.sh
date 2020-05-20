#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

triplet="aarch64-linux-gnu"

cd /src/iproute2

make distclean

PKG_CONFIG="${triplet}-pkg-config" CC="${triplet}-gcc" AR="${triplet}-ar" ./configure

make -j "$(getconf _NPROCESSORS_ONLN)"

${triplet}-strip ip/ip
${triplet}-strip tc/tc

mkdir -p /out/linux/arm64/bin
cp ip/ip tc/tc /out/linux/arm64/bin
