#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

cd /src/iproute2

./configure

make -j "$(getconf _NPROCESSORS_ONLN)"

strip ip/ip
strip tc/tc

mkdir -p /out/linux/amd64/bin
cp ip/ip tc/tc /out/linux/amd64/bin
