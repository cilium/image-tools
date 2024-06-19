#!/bin/bash

# Copyright 2017-2020 Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

packages=(
  automake
  binutils
  bison
  build-essential
  ca-certificates
  cmake
  curl
  flex
  g++
  gcc-9
  git
  libelf-dev
  libmnl-dev
  libtool
  make
  ninja-build
  pkg-config
  python3
  python3-pip
  unzip
)

packages_amd64=(
  binutils-aarch64-linux-gnu
  crossbuild-essential-arm64
  g++-aarch64-linux-gnu
  gcc-9-aarch64-linux-gnu
  libelf-dev:arm64
)

export DEBIAN_FRONTEND=noninteractive

cat > /etc/apt/sources.list.d/ubuntu.sources << EOF
Types: deb
URIs: http://archive.ubuntu.com/ubuntu/
Suites: noble noble-updates noble-backports
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
Architectures: amd64

## Ubuntu security updates. Aside from URIs and Suites,
## this should mirror your choices in the previous section.
Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: noble-security
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
Architectures: amd64

Types: deb
URIs: http://ports.ubuntu.com/
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
Architectures: arm64

Types: deb
URIs: http://ports.ubuntu.com/ubuntu-ports/
Suites: noble-security
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
Architectures: arm64
EOF

if [ "$(uname -m)" == "x86_64" ] ; then
  dpkg --add-architecture arm64
fi

apt-get update

ln -fs /usr/share/zoneinfo/UTC /etc/localtime

apt-get install -y --no-install-recommends "${packages[@]}"
if [ "$(uname -m)" == "x86_64" ] ; then
  apt-get install -y --no-install-recommends "${packages_amd64[@]}"
fi

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 2
if [ "$(uname -m)" == "x86_64" ] ; then
  update-alternatives --install /usr/bin/aarch64-linux-gnu-gcc aarch64-linux-gnu-gcc /usr/bin/aarch64-linux-gnu-gcc-9 3
fi
