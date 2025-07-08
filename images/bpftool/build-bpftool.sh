#!/usr/bin/env bash

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

cd /src/linux/tools/bpf/bpftool

make -j "$(getconf _NPROCESSORS_ONLN)"

strip bpftool

mkdir -p /out/bin
cp bpftool /out/bin
