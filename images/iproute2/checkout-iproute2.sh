#!/bin/bash

# Copyright 2017-2021 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

rev="9ee52f43f2fa4b2dfb655ec5247a3e8d16ada88c" # libbpf-static-data

# git clone https://github.com/cilium/iproute2 /src/iproute2
# cd /src/iproute2
# git checkout -b "build-${rev:0:7}" "${rev}

# It is much quicker to download a tarball then a full git checkout
curl --fail --show-error --silent --location "https://github.com/cilium/iproute2/archive/${rev}.tar.gz" --output /tmp/iproute2.tgz
mkdir -p /src
tar -xf /tmp/iproute2.tgz -C /tmp
mv "/tmp/iproute2-${rev}" /src/iproute2
rm -f /tmp/iproute2.tgz
