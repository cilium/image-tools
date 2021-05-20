#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright 2020-2021 Authors of Cilium

set -e

apt-get install -y --no-install-recommends git bison flex pkg-config ca-certificates

git clone -b static-data --depth 1 https://github.com/cilium/iproute2
cd iproute2
git apply ../iproute2.diff
make -j"$(nproc)"
cd ..

cp iproute2/tc/tc /bin/
cp iproute2/ip/ip /bin/

rm -r iproute2
apt-get autoremove -y git bison flex pkg-config ca-certificates
apt-get purge --auto-remove
