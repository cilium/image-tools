#!/bin/bash

# Copyright 2017-2021 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

rev="435a6def05b1dd7d1e8e19946315122f7e1e776a"

# git clone https://github.com/libbpf/libbpf /src/libbpf
# cd /src/libbpf
# git checkout -b "build-${rev:0:7}" "${rev}

# It is much quicker to download a tarball then a full git checkout,
curl --fail --show-error --silent --location "https://github.com/cilium/libbpf/archive/${rev}.tar.gz" --output /tmp/libbpf.tgz
mkdir -p /src
tar -xf /tmp/libbpf.tgz -C /tmp
mv "/tmp/libbpf-${rev}" /src/libbpf
rm -f /tmp/libbpf.tgz
